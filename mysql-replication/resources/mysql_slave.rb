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
    mysql -u root -h 127.0.0.1 -pmysql -e "CHANGE MASTER TO MASTER_HOST = '35.171.206.5', MASTER_USER = 'repl', MASTER_PASSWORD = 'mysql', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 868;"
    mysql -u root -h 127.0.0.1 -pmysql -e "start slave;"
  EOH
 end
end
