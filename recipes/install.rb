#
# Cookbook Name:: redis_wrapper_cluster
# Recipe:: install
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


include_recipe 'redisio::_install_prereqs'
include_recipe 'build-essential::default'


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

template '/opt/redis-3.0.3/redis.conf' do
  source 'redis.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'

end

template '/etc/init.d/redis-server' do
  source 'redis-server.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

service "redis-server" do
  action :start
end

tag('redis')

if node['fqdn'].gsub(/[^\d]/, '')[0].to_i.odd?
  tag('redis_master')
else
  tag('redis_slave')
end
