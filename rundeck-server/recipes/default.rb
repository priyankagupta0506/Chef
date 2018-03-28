#chef :: default recipe
rundeck_server 'rundeckd' do
  action [:create, :start]
end
