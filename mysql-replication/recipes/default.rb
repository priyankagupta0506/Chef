#
# Cookbook Name:: mysql-replication
# Recipe:: default
#
# Copyright 2015 Pavel Yudin
#

mysql_master "master" do
  action [:create]
end
