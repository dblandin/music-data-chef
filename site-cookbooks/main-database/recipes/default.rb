postgres             = Chef::EncryptedDataBagItem.load('users', 'postgres')
postgres_user        = Chef::EncryptedDataBagItem.load('postgres', 'user')
database             = node[:app][:name].gsub('-', '_')

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
