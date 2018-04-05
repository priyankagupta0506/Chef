mysql_service_direct "" do
  port '3306'
  version '5.5'
  bind_address '0.0.0.0'
  mysqld_options 'innodb_buffer_pool_size' => '64M'
  initial_root_password 'mysql'
  action [:create, :start]
end
