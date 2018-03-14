#
# Cookbook Name:: mysql-replication
# Recipe:: default
#
# Copyright 2015 Pavel Yudin
#

mysql_master "master" do
  port '3306'
  action [:create]
end
