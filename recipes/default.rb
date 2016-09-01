#
# Cookbook Name:: redis_wrapper_cluster
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.



include_recipe 'redis_wrapper_cluster::install'

include_recipe 'redis_wrapper_cluster::master'
include_recipe 'redis_wrapper_cluster::slaves'

include_recipe 'redis_wrapper_cluster::remove'
