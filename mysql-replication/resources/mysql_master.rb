property :instance, kind_of: String, name_attribute: true
property :id, kind_of: Integer
property :log_bin, kind_of: String, default: 'mysql-bin'
property :user, kind_of: String, default: 'repl'
property :host, kind_of: String, default: '%'
property :password, kind_of: String, required: false
property :binlog_do_db, kind_of: [Array, String]
property :binlog_ignore_db, kind_of: [Array, String]
property :binlog_format, kind_of: String, default: 'MIXED'
property :options, kind_of: Hash

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
              binlog_ignore_db: new_resource.binlog_ignore_db,
              options: new_resource.options
    action :create
    notifies :restart, "mysql_service[#{new_resource.name}]", :immediately
  end

  execute 'Grant permissions' do
    command "echo \" GRANT SELECT,REPLICATION CLIENT,RELOAD,REPLICATION SLAVE ON *.* TO '#{new_resource.user}'@'#{new_resource.host}'
             IDENTIFIED BY PASSWORD '#{mysql_password(new_resource.password)}' \" | mysql -S #{mysql_socket}"
    environment 'MYSQL_PWD' => mysql_instance.initial_root_password
    not_if "echo \"SHOW GRANTS FOR '#{new_resource.user}'@'#{new_resource.host}';\" | mysql -S #{mysql_socket}",
           environment: { 'MYSQL_PWD' => mysql_instance.initial_root_password }
  end
end

action :delete do
  mysql_config 'master' do
    instance new_resource.name
    action :delete
  end

  execute 'Remove permissions' do
    command "echo \"DROP USER '#{new_resource.user}'@'#{new_resource.host}';\" | mysql -S #{mysql_socket}"
    environment 'MYSQL_PWD' => mysql_instance.initial_root_password
    action :run
    only_if "echo \"SHOW GRANTS FOR '#{new_resource.user}'@'#{new_resource.host}';\" | mysql -S #{mysql_socket}",
            environment: { 'MYSQL_PWD' => mysql_instance.initial_root_password }
  end
end
