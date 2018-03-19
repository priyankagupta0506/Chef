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
  master_host '35.172.108.141'
  master_port 3306
  instance 'ops'
  id 2
  user 'repl'
  binlog_do_db %w(test1)
  replicate_do_db %w(test1)
  relay_log '/var/log/mysql/mysql-relay-bin.log'
end

execute "create test1" do
  command "mysql -u root -h 127.0.0.1 -pmysql | echo "create database if not exists test1;""
end
