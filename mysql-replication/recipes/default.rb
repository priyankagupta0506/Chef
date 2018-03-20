#
# Cookbook Name:: mysql-replication
# Recipe:: default
#
# Copyright 2015 Pavel Yudin
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
  password 'mysql'
end

execute 'Create database test1' do
  command "mysql -u root -h 127.0.0.1 -pmysql | echo 'create database if not exists test1;'"
end
