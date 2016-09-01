#
# Cookbook Name:: redis_wrapper_cluster
# Recipe:: install
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Install dependencies first from redisio 
include_recipe 'redisio::_install_prereqs'
include_recipe 'build-essential::default'

#TODO Move to standard provider install 
#TODO move common variables to attributes -opt/redis-3.0.3 etc
script "install_redis-server" do
  not_if {File.exists?('/opt/redis-3.0.3')}
  interpreter "bash"
  user "root"
  cwd "/opt"
  code <<-EOH
    wget http://download.redis.io/releases/redis-3.0.3.tar.gz
    tar -zxf redis-3.0.3.tar.gz
    cd redis-3.0.3
    make
    make install
  EOH
end
# Template with base details for a cluster
template '/opt/redis-3.0.3/redis.conf' do
  source 'redis.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'

end

# Template for redis restart
template '/etc/init.d/redis-server' do
  source 'redis-server.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

service "redis-server" do
  action :start
end

# Tag all ndoes as redis - used for  node query later  to look for any disconnected nodes etc
tag('redis')

# If Node Name has odd number's it will install master redis , else it will install slave redis
# eg : redis-1 / redis-1.dc1.company.com Tag node accordingly to be used by node search later .
if node['fqdn'].gsub(/[^\d]/, '')[0].to_i.odd?
  tag('redis_master')
else
  tag('redis_slave')
end
