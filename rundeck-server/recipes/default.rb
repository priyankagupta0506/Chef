#chef :: default recipe
rundeck_server do
  action [:create, :start]
end
