#
# Cookbook Name:: redis_wrapper_cluster
# Recipe:: remove
#
# Copyright (c) 2016 The Authors, All Rights Reserved.



  ruby_block "all_disconnected_nodes_from_redis_process" do
      block do
          #tricky way to load this Chef::Mixin::ShellOut utilities
          Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
          command = "redis-cli  -p 6379 cluster nodes | grep disconnected | awk '{print $1}'"
          command_out = shell_out(command)
          node.set['all_nodes_from_redis_process'] = command_out.stdout
          puts "******************** #{command_out.stdout} "
          command  = "/opt/redis-3.0.3/src/redis-trib.rb del-node    #{node['fqdn']}:6379  #{command_out.stdout} "
          command_out = shell_out(command)
          puts "******************** #{command_out.stdout} "

      end
      action :create
  end
