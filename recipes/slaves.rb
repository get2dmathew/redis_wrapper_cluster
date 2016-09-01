#
# Cookbook Name:: redis_wrapper_cluster
# Recipe:: slave
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# If Node Name has even number's it will install master redis , else it will install slave redis
# eg : redis-1 / redis-1.dc1.company.com

gem_package 'redis'

node_number=node['fqdn'].gsub(/[^\d]/, '')[0]
previous_node_number = node['fqdn'].gsub(/[^\d]/, '')[0].to_i-1
previous_node_name = node['fqdn'].gsub("#{node_number}","#{previous_node_number}")
if node['fqdn'].gsub(/[^\d]/, '')[0].to_i.even?

  slave_node = search('node', "tags:redis_slave  AND  name:#{node['fqdn']} AND chef_environment:#{node.chef_environment} AND  NOT tags:redis-registered")

 # function to calcuate  the previous node and add that to below search ignore ! name.
  master_for_slave = search('node', "tags:redis_master  AND  tags:redis-registered AND chef_environment:#{node.chef_environment} AND NOT  name:#{previous_node_name} ")
  if !slave_node.nil?
    execute 'add slave node' do
        command "/opt/redis-3.0.3/src/redis-trib.rb add-node --slave    #{node['fqdn']}:6379  #{master_for_slave[0].name}:6379 "
      end
     tag('redis-registered')
end

end
