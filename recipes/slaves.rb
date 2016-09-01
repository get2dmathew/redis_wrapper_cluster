#
# Cookbook Name:: redis_wrapper_cluster
# Recipe:: slave
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# If Node Name has even number's it will install master redis , else it will install slave redis
# eg : redis-1 / redis-1.dc1.company.com

# Install dependency gem package redis for `redis-trib.rb add-node`
gem_package 'redis'

# Logic to make sure we dont add the previous node (Numeric Order) as master to this slave 
# TODO Move to a function all the node name checks
node_number=node['fqdn'].gsub(/[^\d]/, '')[0]
previous_node_number = node['fqdn'].gsub(/[^\d]/, '')[0].to_i-1
previous_node_name = node['fqdn'].gsub("#{node_number}","#{previous_node_number}")

# Install slave if node has even number in name .
# TODO I can remove [0] check , for my test I had two numbers (redis-1.dc1.company.com_  thus adding [0] 
if node['fqdn'].gsub(/[^\d]/, '')[0].to_i.even?
 
  #Make sure if current node is not yet added as a slave in the cluster , mainly NOT tags:redis-registered check ..
  slave_node = search('node', "tags:redis_slave  AND  name:#{node['fqdn']} AND chef_environment:#{node.chef_environment} AND  NOT tags:redis-registered")

 # function to calcuate  the previous node and add that to below search ignore ! name.
  master_for_slave = search('node', "tags:redis_master  AND  tags:redis-registered AND chef_environment:#{node.chef_environment} AND NOT  name:#{previous_node_name} ")
  if !slave_node.nil?
    # add node as a slave to a diff master other than previous node 
    execute 'add slave node' do
        command "/opt/redis-3.0.3/src/redis-trib.rb add-node --slave    #{node['fqdn']}:6379  #{master_for_slave[0].name}:6379 "
      end
      # Tag node as -registered
      # TODO check execute worked before tagging . Can you execute `returns` value . tag only if `returns` variable is 0 .
     tag('redis-registered')
end

end
