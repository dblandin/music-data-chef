deploy = Chef::EncryptedDataBagItem.load('users', 'deploy')

directory '/var/run' do
  owner 'www-data'
  group 'sudo'
  mode '0755'
  recursive true
end

directory "/var/www/#{node[:app][:name]}" do
  owner deploy['name']
  group 'sudo'
  mode '0755'
  recursive true
end

directory "/tmp/#{node[:app][:name]}" do
  owner deploy['name']
  group 'sudo'
  mode '0755'
  recursive true
end

cookbook_file 'nginx.conf' do
  path node.nginx.dir
  mode '0777'
  owner node.nginx.user
  group node.nginx.user
  action :create_if_missing
end

cookbook_file '10-network-security.conf' do
  path node.nginx.dir
  mode '0777'
  owner node.nginx.user
  group node.nginx.user
  action :create_if_missing
end

template "#{node.nginx.dir}/sites-available/default" do
  source 'site.erb'
  mode '0777'
  owner node.nginx.user
  group node.nginx.user
end
