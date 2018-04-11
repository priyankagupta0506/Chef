#
# Cookbook:: users
# Recipe:: default
#
users_manage 'group' do
  group_id 4000
  action [:create]
  data_bag 'test_home_dir'
  manage_nfs_home_dirs false
end
