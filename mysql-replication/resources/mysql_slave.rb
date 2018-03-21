#
# Cookbook Name:: mysql-replication
# Resource:: mysql_slave
#
property :instance, kind_of: String, name_attribute: true ,default: 'ops'
property :id, kind_of: Integer, default: 2
property :master_host, kind_of: String, required: true,default: '35.172.108.141'
property :bind_address, kind_of: String, default: '127.0.0.1'
property :master_port, kind_of: Integer, default: 3306
property :user, kind_of: String, default: 'repl'
property :password, kind_of: String, required: true, default: 'mysql'
property :database, kind_of: [String, Array]
property :log_bin, kind_of: String, default: '/var/log/mysql/mysql-bin.log'
property :relay_log, kind_of: String, default: '/var/log/mysql/mysql-relay-bin'
property :replicate_ignore_db, kind_of: [String, Array], default: 'mysql'
property :replicate_do_db, kind_of: [String, Array], default: 'test1'
property :timeout, kind_of: Integer
property :options, kind_of: Hash

provides :mysql_slave
default_action :create

action :create do
  databases = new_resource.database ? [new_resource.database].flatten : master_databases
  mysql_config 'slave' do
    cookbook 'mysql-replication'
    instance new_resource.name
    source 'slave.conf.erb'
    variables id: new_resource.id || node['ipaddress'].split('.').join(''),
              database: new_resource.database,
              replicate_ignore_db: new_resource.replicate_ignore_db,
              replicate_do_db: new_resource.replicate_do_db,
              relay_log: new_resource.relay_log,
              log_bin: new_resource.log_bin,
              options: new_resource.options
    action :create
    notifies :restart, "mysql_service[ops]", :immediately
  end
 bash 'Start replication' do
  code <<-EOH
    mysql -u root -h 127.0.0.1 -pmysql -e "CHANGE MASTER TO MASTER_HOST = '35.172.108.141', MASTER_USER = 'repl', MASTER_PASSWORD = 'mysql', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 737;"
    mysql -u root -h 127.0.0.1 -pmysql -e "start slave;"
  EOH
 end
end 

#  execute "Start replication" do
#    command "mysql -u root -h 127.0.0.1 -pmysql | echo \" CHANGE MASTER TO MASTER_HOST = '35.172.108.141', MASTER_USER = 'repl', MASTER_PASSWORD = 'mysql', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 107; \" | echo \" start slave; \" | echo \" show slave status \""
#    action :run
#  end
# end
#if node["platform"] == "ubuntu"
# end
#dump_file = ::File.join(Chef::Config[:file_cache_path], "#{new_resource.name}-dump.sql")
#  ruby_block 'Start replication' do
#    block do
#      master_file, master_position = get_master_file_and_position(dump_file)

 #     command_master = %(
 #       CHANGE MASTER TO
 #       MASTER_HOST="35.172.108.141",
 #       MASTER_PORT=3306,
 #       MASTER_USER="repl",
 #       MASTER_PASSWORD="mysql",
 #       MASTER_LOG_FILE="mysql-bin.000001",
 #       MASTER_LOG_POS=107;
 #     )

 #     result = Mixlib::ShellOut.new("echo '#{command_master}' | mysql -S #{mysql_socket}", env: { 'MYSQL_PWD' => mysql_instance.initial_root_password })
 #     result.run_command
 #     result.error!

 #     result = Mixlib::ShellOut.new("echo 'start slave' | mysql -S #{mysql_socket}", env: { 'MYSQL_PWD' => mysql_instance.initial_root_password })
 #     result.run_command
 #     result.error!
 #   end
 #   not_if { replication_enabled?(mysql_socket, mysql_instance.initial_root_password) }
 # end

#  file dump_file do
#    action :delete
#  end
#end

#  execute 'Get dump' do
#    command "mysqldump -h #{new_resource.master_host} -P #{new_resource.master_port} \
#             -u #{new_resource.user} --master-data=2 --single-transaction \
#             --databases #{databases.join(' ')} > #{dump_file}"
#    environment 'MYSQL_PWD' => new_resource.password
#    action :run
#    not_if { replication_enabled?(mysql_socket, mysql_instance.initial_root_password) }
#  end

#  execute 'Upload dump' do
#    command "cat #{dump_file} | mysql -S #{mysql_socket}"
#    environment 'MYSQL_PWD' => mysql_instance.initial_root_password
#    timeout new_resource.timeout if new_resource.timeout
#    not_if { replication_enabled?(mysql_socket, mysql_instance.initial_root_password) }
#  end
