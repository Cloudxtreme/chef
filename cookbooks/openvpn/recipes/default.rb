#
# Cookbook Name:: openvpn
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

include_recipe "openvpn::lzo"

unless File.exists?("/usr/local/openvpn-#{node[:openvpn][:version]}")
  extract "openvpn-#{node[:openvpn][:version]}" do
    action :enable
  end

  build_src "openvpn-#{node[:openvpn][:version]}" do
    action :enable
    options "--prefix=/usr/local/openvpn-#{node[:openvpn][:version]}"
  end

  execute "cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/openvpn-#{node[:openvpn][:version]}"
  end
end

directory "/usr/local/openvpn-#{node[:openvpn][:version]}/etc" do
  owner "root"
  group "root"
  mode 0755
end

link "/usr/local/openvpn" do
  to "/usr/local/openvpn-#{node[:openvpn][:version]}"
  not_if "[ -L /usr/local/openvpn ]"
end

template "/etc/init.d/openvpn" do
  source "openvpn.init.erb"
  backup 0
  mode "0755"
  owner "root"
  group "root"
end

service "openvpn" do
  action :enable
end

