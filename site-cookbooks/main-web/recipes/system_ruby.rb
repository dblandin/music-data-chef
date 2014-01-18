ruby_build_ruby node[:ruby_version] do
  prefix_path '/usr/local'
  action :install
end

gem_package 'bundler'
