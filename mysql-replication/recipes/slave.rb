#
# Cookbook Name:: mysql-replication
# Recipe:: default
#
# Copyright 2015 Pavel Yudin
#
mysql_service 'ops' do
  version '5.5'
  bind_address '0.0.0.0'
  port 3306
  initial_root_password 'mysql'
  socket '/var/run/mysql-ops/mysqld.sock'
  mysqld_options 'innodb_buffer_pool_size' => '64M'
  action [:create, :start]
end

mysql_slave 'ops' do
  master_host '35.171.206.5'
  master_port 3306
  instance 'ops'
  password 'mysql'
  database 'test1'
  log_bin '/var/log/mysql/mysql-bin.log'
  relay_log '/var/log/mysql/mysql-relay-bin.log'
  id 2
  user 'repl'
end
