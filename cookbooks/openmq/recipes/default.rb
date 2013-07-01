#
# Cookbook Name:: openmq
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

group "openmq" do
  gid 2006
end

user "openmq" do
  uid 2006
  gid 2006
  home "/home/openmq"
  shell "/bin/bash"
end

unless File.exists?("/usr/local/openmq-#{node[:openmq][:version]}")
  build_bin_full "openmq-#{node[:openmq][:version]}" do
    action :enable
    install_dest "/usr/local/openmq-#{node[:openmq][:version]}"
    user "openmq"
    group "openmq"
    symlink "/usr/local/openmq"
  end
end

execute "create openmq instance" do
  command "cp -arp /usr/local/openmq-#{node[:openmq][:version]}/var/mq/instances/default /usr/local/openmq-#{node[:openmq][:version]}/var/mq/instances/#{node[:openmq][:instance]}"
  not_if "[ -d /usr/local/openmq-#{node[:openmq][:version]}/var/mq/instances/#{node[:openmq][:instance]} ]"
end

execute "chmod 755 imq" do
  command "chmod 755 /usr/local/openmq-#{node[:openmq][:version]}/etc/mq/rc/imq"
  not_if "[ $(stat -c '%a' /usr/local/openmq-#{node[:openmq][:version]}/etc/mq/rc/imq) == '755' ]"
end

link "/etc/init.d/imq" do
  to "/usr/local/openmq/etc/mq/rc/imq"
  not_if "[ -L /etc/init.d/imq ]"
end

template "/etc/profile.d/openmq.sh" do
  source "openmq.sh.erb"
  backup 0
  mode 0755
  owner "root"
  group "root"
end

template "/usr/local/openmq-#{node[:openmq][:version]}/var/mq/instances/#{node[:openmq][:instance]}/props/config.properties" do
  source "config.properties.erb"
  mode 0664
  owner "openmq"
  group "openmq"
end

template "/usr/local/openmq-#{node[:openmq][:version]}/var/mq/instances/#{node[:openmq][:instance]}/etc/passwd" do
  source "passwd.erb"
  mode 0600
  owner "openmq"
  group "openmq"
end
