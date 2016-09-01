#
# Cookbook Name:: redis_wrapper_cluster
# Recipe:: master
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# If Node Name has odd number's it will install master redis , else it will install slave redis
# eg : redis-1 / redis-1.dc1.company.com


if node['fqdn'].gsub(/[^\d]/, '')[0].to_i.odd?

  tag('redis_master')

  master_node = search('node', "tags:redis_master AND chef_environment:#{node.chef_environment} AND NOT tags:redis-registered  ")
  #master_node.sort_by!{ |n| n[:name] }
  all_master_nodes=""
  master_node.each do |node|
    all_master_nodes <<   "#{node.name}:6379 "
 end

  if !master_node.nil? && master_node.count >=3
    Chef::Log.info('Minium  Master Servers for Cluster found ! Adding  masters to cluster ')
      #execute 'apache_configtest' do
      #  command "/opt/redis-3.0.3/src/redis-trib.rb create  #{all_master_nodes}"
      #end
      bash 'Install Master Cluster' do
          user 'root'
          code <<-EOF
          /usr/bin/expect -c 'spawn /opt/redis-3.0.3/src/redis-trib.rb create  #{all_master_nodes}
          expect "Can I set the above configuration? (type 'yes' to accept): "
          send "yes\r"
          expect eof'
          EOF
      end


     tag('redis-registered')
  else

     errmsg = "Need minimun 3 masters for cluster. Only #{master_node.count} found Will install cluster once we have minium servers !!!"
     Chef::Application.fatal!(errmsg, 1)

  end
end
