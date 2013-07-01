#
# Cookbook Name:: nginx
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

install_dir = node[:nginx][:install_dir]

unless File.exists?("#{node[:nginx][:install_dir]}/nginx-#{node[:nginx][:version]}")
  install_flags = node[:nginx][:install_modules].map do |mod|
    "--with-#{mod}"
  end.join(" ")

  extract "nginx-upstream-fair" do
    action :enable
  end

  extract "nginx-#{node[:nginx][:version]}" do
    action :enable
  end

  build_src "nginx-#{node[:nginx][:version]}" do
    action :enable
    options "--prefix=#{node[:nginx][:install_dir]}/nginx-#{node[:nginx][:version]} #{install_flags} --add-module=#{node[:common][:tmp_dir]}/nginx-upstream-fair"
  end

  execute "cleanup nginx" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/nginx-#{node[:nginx][:version]}"
  end

  execute "cleanup nginx upstream fair" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/nginx-upstream-fair"
  end
end

link "/usr/local/nginx" do
  to "#{node[:nginx][:install_dir]}/nginx-#{node[:nginx][:version]}"
  not_if "[ -L /usr/local/nginx ]"
end

case node[:platform]
when "centos","redhat","fedora"
  src = "nginx.erb"
when "ubuntu","debian"
  src = "nginx.ubuntu.erb"
end

template "/etc/init.d/nginx" do
  source "#{src}"
  mode "0755"
  owner "root"
  group "root"
end

service "nginx" do
  action :enable
end

