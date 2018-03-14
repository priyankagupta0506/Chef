mysql_service 'mysql' do
  port '3306'
  version '5.5'
  initial_root_password 'mysql'
  action [:create, :start]
end
mysql_config 'mysql' do
  source 'my_extra_settings.erb'
  notifies :restart, 'mysql_service[mysql]'
  action :create
end
