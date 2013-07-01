#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2009, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

packages = %w{
	  curl
	  curl-devel
	  libevent
	  libevent-devel
	}

packages.each do |pkg|
  package pkg do
    action :install
    not_if "rpm -q #{pkg}"
  end
end

include_recipe "php::fpm"
include_recipe "php::re2c"

link "/usr/local/php" do
  to "/usr/local/php-#{node[:php][:version]}"
  not_if "[ -L /usr/local/php ]"
end
