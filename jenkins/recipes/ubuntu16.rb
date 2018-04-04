#chef :: default recipe
jenkins_server_16 'jenkins' do
  action [:create, :start]
end
