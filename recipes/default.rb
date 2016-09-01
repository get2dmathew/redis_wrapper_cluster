#
# Cookbook Name:: redis_wrapper_cluster
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


## Install Base Redis 3.* version with cluster feature and tag node with redis_master or redis_slave based on Node type (Odd/Even)
include_recipe 'redis_wrapper_cluster::install'

## Add Node to Cluster as master if its a master Node
include_recipe 'redis_wrapper_cluster::master'

## Add Node to Cluster as slave  if its a slave  Node
include_recipe 'redis_wrapper_cluster::slaves'

## Recipe to remove disconnected Nodes
include_recipe 'redis_wrapper_cluster::remove'
