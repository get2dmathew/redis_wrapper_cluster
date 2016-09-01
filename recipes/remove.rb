#
# Cookbook Name:: redis_wrapper_cluster
# Recipe:: remove
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# Fast way to remove disconnected nodes from the cluster
# TODO - Use a LWRP for all redis-trib.rb functions 
  ruby_block "all_disconnected_nodes_from_redis_process" do
      block do
          #tricky way to load this Chef::Mixin::ShellOut utilities
          Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
          # Check for any disconnected nodes and get their cluster node-id  
          command = "redis-cli  -p 6379 cluster nodes | grep disconnected | awk '{print $1}'"
          command_out = shell_out(command)
          node.set['all_nodes_from_redis_process'] = command_out.stdout
          puts "******************** #{command_out.stdout} "
          # Delete `node-id ` from cluster which is disconnected  using redis-trib.rb del-node
          command  = "/opt/redis-3.0.3/src/redis-trib.rb del-node    #{node['fqdn']}:6379  #{command_out.stdout} "
          command_out = shell_out(command)
          puts "******************** #{command_out.stdout} "

      end
      action :create
  end
