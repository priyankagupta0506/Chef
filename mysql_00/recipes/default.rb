#
mysql_service_direct 'mysql' do
  action [:create, :start]
end
