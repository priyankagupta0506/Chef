#chef :: default recipe
jenkins_server 'jenkins' do
  action [:create, :start]
end
