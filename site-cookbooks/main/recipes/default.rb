deploy               = Chef::EncryptedDataBagItem.load('users', 'deploy')
home_dir             = "/home/#{deploy['name']}"
authorized_keys_file = "#{home_dir}/.ssh/authorized_keys"

user deploy['name'] do
  password deploy['password']
  gid 'sudo'
  home "/home/#{deploy['name']}"
  shell '/bin/bash'
  supports manage_home: true
end

directory "#{home_dir}/.ssh" do
  owner deploy['name']
  group 'sudo'
  mode '755'
  recursive true
end

file authorized_keys_file do
  owner deploy['name']
  mode  0600
  content deploy['ssh-key']
  not_if { ::File.exists?("#{authorized_keys_file}")}
end
