#
# Cookbook Name:: mysql-replication
# Recipe:: default
#
# Copyright 2015 Pavel Yudin
#

package "mysql, ~> 6.0" do
  acion :install
end

package "resources::mysql_master" do
  action :install
end
