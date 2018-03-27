module MysqlCookbook
  class MysqlServiceManagerUpstart < MysqlServiceBase
    resource_name :mysql_service_manager_upstart

    provides :mysql_service_manager, platform_family: 'debian' do |_node|
      Chef::Platform::ServiceHelpers.service_resource_providers.include?(:upstart) &&
        !Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd) &&
        !Chef::Platform::ServiceHelpers.service_resource_providers.include?(:redhat) &&
        ::File.exist?('/sbin/status') # Fix for Docker, in 7 and 8 images /sbin/status doesn't exists and Upstart provider doesn't work
    end

    action :create do
      # from base
      create_system_user
      #stop_system_service
      create_config
      initialize_database
    end

    action :start do
      template "/usr/sbin/mysql-wait-ready" do
        source 'upstart/mysqld-wait-ready.erb'
        owner 'root'
        group 'root'
        mode '0755'
        variables(socket_file: '/var/run/mysql-ops/mysqld.sock')
        cookbook 'mysql'
        action :create
      end

      template "/etc/init/mysql.conf" do
        source 'upstart/mysqld.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          defaults_file: '/etc/mysql/my.cnf',
          mysql_name: 'mysql',
          run_group: 'root',
          run_user: 'root',
          socket_dir: '/var/run/mysql'
        )
        cookbook 'mysql'
        action :create
      end

      service mysql_name do
        provider Chef::Provider::Service::Upstart
        supports status: true
        action [:start]
      end
    end

    action :stop do
      service mysql_name do
        provider Chef::Provider::Service::Upstart
        supports restart: true, status: true
        action [:stop]
      end
    end

    action :restart do
      # With Upstart, restarting the service doesn't behave "as expected".
      # We want the post-start stanzas, which wait until the
      # service is available before returning
      #
      # http://upstart.ubuntu.com/cookbook/#restart
      service mysql_name do
        provider Chef::Provider::Service::Upstart
        action [:stop, :start]
      end
    end

    action :reload do
      # With Upstart, reload just sends a HUP signal to the process.
      # As far as I can tell, this doesn't work the way it's
      # supposed to, so we need to actually restart the service.
      service mysql_name do
        provider Chef::Provider::Service::Upstart
        action [:stop, :start]
      end
    end

    #action_class do
      #def stop_system_service
        #service system_service_name do
          #provider Chef::Provider::Service::Upstart
          #supports status: true
          #action [:stop, :disable]
        #end
      #end

      #def delete_stop_service
        #service mysql_name do
          #provider Chef::Provider::Service::Upstart
          #action [:disable, :stop]
          #only_if { ::File.exist?("#{etc_dir}/init/mysql") }
        #end
      #end
    #end
  end
end
