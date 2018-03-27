module MysqlCookbook
  class MysqlServiceManagerSystemd < MysqlServiceBase
    resource_name :mysql_service_manager_systemd

    provides :mysql_service_manager, os: 'linux' do |_node|
      Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
    end

    action :create do
      # from base
      create_system_user
      stop_system_service
      configure_apparmor
      create_config
      initialize_database
    end

    action :start do
      # Needed for Debian / Ubuntu
      directory '/usr/libexec' do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end

      # this script is called by the main systemd unit file, and
      # spins around until the service is actually up and running.
      template "/usr/libexec/mysql-wait-ready" do
        path "/usr/libexec/mysql-wait-ready"
        source 'systemd/mysqld-wait-ready.erb'
        owner 'root'
        group 'root'
        mode '0755'
        variables(socket_file: "/var/run/mysql/mysqld.sock")
        cookbook 'mysql'
        action :create
      end

      # this is the main systemd unit file
      template "/etc/systemd/system/mysql.service" do
        path "/etc/systemd/system/mysql.service"
        source 'systemd/mysqld.service.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          config: new_resource,
          etc_dir: "/etc/mysql",
          base_dir: "/usr",
          mysqld_bin: "/usr/sbin/mysqld"
        )
        cookbook 'mysql'
        notifies :run, "execute[mysql systemctl daemon-reload]", :immediately
        action :create
      end

      # avoid 'Unit file changed on disk' warning
      execute "mysql systemctl daemon-reload" do
        command '/bin/systemctl daemon-reload'
        action :nothing
      end

      # tmpfiles.d config so the service survives reboot
      template "/usr/lib/tmpfiles.d/mysql.conf" do
        path "/usr/lib/tmpfiles.d/mysql.conf"
        source 'tmpfiles.d.conf.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          run_dir: "/var/run/mysql",
          run_user: new_resource.run_user,
          run_group: new_resource.run_group
        )
        cookbook 'mysql'
        action :create
      end

      # service management resource
      service mysql_name.to_s do
        service_name mysql_name
        provider Chef::Provider::Service::Systemd
        supports restart: true, status: true
        action [:enable, :start]
      end
    end

    action :stop do
      # service management resource
      service mysql_name.to_s do
        service_name mysql_name
        provider Chef::Provider::Service::Systemd
        supports status: true, restart: true
        action [:disable, :stop]
        only_if { ::File.exist?("/usr/lib/systemd/system/mysql.service") }
      end
    end

    action :restart do
      # service management resource
      service mysql_name.to_s do
        service_name "mysql"
        provider Chef::Provider::Service::Systemd
        supports restart: true, start:true, stop:true
        action [:stop, :start]
      end
    end

    action :reload do
      # service management resource
      service mysql_name.to_s do
        service_name "mysql"
        provider Chef::Provider::Service::Systemd
        action :reload
      end
    end

    action_class do
      def stop_system_service
        # service management resource
        service 'mysql' do
          service_name system_service_name
          provider Chef::Provider::Service::Systemd
          supports status: true
          action [:stop, :disable]
        end
      end

      def delete_stop_service
        # service management resource
        service mysql_name.to_s do
          service_name "mysql"
          provider Chef::Provider::Service::Systemd
          supports status: true
          action [:disable, :stop]
          only_if { ::File.exist?("/usr/lib/systemd/system/mysql.service") }
        end
      end
    end
  end
end
