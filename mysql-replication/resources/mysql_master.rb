property :instance, kind_of: String, name_attribute: true ,default: 'ops'
property :id, kind_of: Integer,default: '1'
property :log_bin, kind_of: String, default: '/var/log/mysql/mysql-bin.log'
property :user, kind_of: String, default: 'repl'
property :host, kind_of: String, default: '%'
property :password, kind_of: String, required: true, default: 'mysql'
property :binlog_do_db, kind_of: [Array, String], default: 'test1'
property :binlog_ignore_db, kind_of: [Array, String]
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
    mysql -u root -h 127.0.0.1 -S /var/run/mysql-ops/mysqld.sock --password="" -e "UPDATE mysql.user SET Password=PASSWORD('mysql') WHERE User='root';"
    mysql -u root -h 127.0.0.1 -S /var/run/mysql-ops/mysqld.sock --password="" -e "FLUSH PRIVILEGES;"
    mysql -u root -h 127.0.0.1 -S /var/run/mysql-ops/mysqld.sock --password="mysql" -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY 'mysql';"
    mysql -u root -h 127.0.0.1 -S /var/run/mysql-ops/mysqld.sock --password="mysql" -e "FLUSH PRIVILEGES;"
    mysql -u root --password="mysql" -h 127.0.0.1  -e "show master status;"
    mysql -u root --password="mysql" -h 127.0.0.1  -e "FLUSH TABLES WITH READ LOCK;"
  EOH
end
end
