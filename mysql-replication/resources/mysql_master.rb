property :instance, kind_of: String, name_attribute: true ,default: 'ops'
property :id, kind_of: Integer,default: '1'
property :log_bin, kind_of: String, default: '/var/log/mysql/mysql-bin.log'
property :user, kind_of: String, default: 'repl'
property :host, kind_of: String, default: '%'
property :password, kind_of: String, required: true, default: 'mysql'
property :binlog_do_db, kind_of: [Array, String], default: 'test1'
property :binlog_ignore_db, kind_of: [Array, String], default: 'mysql'
property :binlog_format, kind_of: String, default: 'MIXED'
#property :options, kind_of: Hash

provides :mysql_master
default_action :create

action :create do
  mysql_config 'master' do
    cookbook 'mysql-replication'
    instance new_resource.name
    source 'master.conf.erb'
    variables id: new_resource.id || node['ipaddress'].split('.').join(''),
              log_bin: new_resource.log_bin,
              binlog_format: new_resource.binlog_format,
              binlog_do_db: new_resource.binlog_do_db,
              binlog_ignore_db: new_resource.binlog_ignore_db
    action :create
    notifies :restart, "mysql_service[ops]", :immediately
  end
bash 'Grant permissions' do
  code <<-EOH
    mysql -u root -h 127.0.0.1 -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY PASSWORD 'mysql';"
    mysql -u root -h 127.0.0.1 -e "FLUSH PRIVILEGES;"
    mysql -u root -h 127.0.0.1 -e "CREATE DATABASE test1;"
  EOH
end
end

#if node["platform"] == "ubuntu"
#  execute "Grant permissions" do
#    command "mysql -u root -h 127.0.0.1 | echo \" GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%'
#             IDENTIFIED BY PASSWORD 'mysql' \" | echo \" FLUSH PRIVILEGES \" | echo \" CREATE DATABASE test1 \" | echo \" show master status \""
#    command 'mysql -u root -h 127.0.0.1 -e "show databases"'
#    command 'mysql -u root -h 127.0.0.1 -e "CREATE USER "repl"@'%';"'
#    exec(mysql -u root -h 127.0.0.1 -pmysql -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'127.0.0.1'
#             IDENTIFIED BY PASSWORD 'mysql'") | mysql -S /var/run/mysql-ops/mysqld.sock)

#    environment 'MYSQL_PWD' => mysql_service[ops].initial_root_password
#           environment: { 'MYSQL_PWD' => mysql_service[ops].initial_root_password }
#  end


action :delete do
  mysql_config 'master' do
    instance new_resource.name
    action :delete
  end

  execute 'Remove permissions' do
    command "echo \"DROP USER '#{new_resource.user}'@'#{new_resource.host}';\" | mysql -S /var/run/mysql-ops/mysqld.sock"
#    environment 'MYSQL_PWD' => mysql_instance.initial_root_password
    action :run
#    only_if "echo \"SHOW GRANTS FOR '#{new_resource.user}'@'#{new_resource.host}';\" | mysql -S /var/run/mysql-ops/mysqld.sock",
#            environment: { 'MYSQL_PWD' => mysql_instance.initial_root_password }
  end
end
