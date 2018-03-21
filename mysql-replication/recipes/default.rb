#
# Cookbook Name:: mysql-replication
# Recipe:: default
#
mysql_service 'ops' do
  version '5.5'
  bind_address '0.0.0.0'
  data_dir '/data'
  initial_root_password 'mysql'
  socket '/var/run/mysql-ops/mysqld.sock'
  mysqld_options 'innodb_buffer_pool_size' => '64M'
  action [:create, :start]
end

mysql_master 'ops' do
  binlog_do_db %w(test1)
  id 1
  instance 'ops'
end
