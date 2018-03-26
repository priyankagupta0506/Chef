mysql_service "" do
  port '3306'
  version '5.5'
  initial_root_password 'mysql'
  action [:create, :start]
end
