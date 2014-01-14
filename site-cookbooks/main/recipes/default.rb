deploy               = Chef::EncryptedDataBagItem.load('users', 'deploy')
postgres             = Chef::EncryptedDataBagItem.load('users', 'postgres')
postgres_user        = Chef::EncryptedDataBagItem.load('postgres', 'user')
database             = node[:app][:name].gsub('-', '_')
authorized_keys_file = "/home/#{deploy['name']}/.ssh/authorized_keys"

user deploy['name'] do
  password deploy['password']
  gid 'admin'
  home "/home/#{deploy['name']}"
  shell '/bin/bash'
  supports manage_home: true
end

directory '/var/run' do
  owner 'www-data'
  group 'admin'
  mode '755'
  recursive true
end

directory "/var/www/#{node[:app][:name]}" do
  owner deploy['name']
  group 'admin'
  mode '755'
  recursive true
end

directory "/tmp/#{node[:app][:name]}" do
  owner deploy['name']
  group 'admin'
  mode '755'
  recursive true
end

postgresql_connection_info = {
  host:     '127.0.0.1',
  port:     48189,
  username: postgres['name'],
  password: postgres['password']
}

postgresql_database database do
  connection postgresql_connection_info
  action :create
end

postgresql_database_user postgres_user['name'] do
  connection postgresql_connection_info
  password postgres_user['password']
  action :create
end

postgresql_database_user postgres_user['name'] do
  connection postgresql_connection_info
  database_name database
  privileges [:all]
  action :grant
end

file authorized_keys_file do
  owner deploy['name']
  mode  0600
  content "#{deploy['ssh_key']} #{deploy['name']}"
  not_if { ::File.exists?("#{authorized_keys_file}")}
end

template "#{node.nginx.dir}/sites-available/default" do
  source "site.erb"
  mode '0777'
  owner node.nginx.user
  group node.nginx.user
end
