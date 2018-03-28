#chef :: default recipe
rundeck_server 'rundeck' do
  action [:create, :start]
end
