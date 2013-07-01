#
# Cookbook Name:: mysql
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

case node[:platform]
when "centos","redhat","fedora"
  packages = %W{
      MySQL-devel-#{node[:mysql][:devel_ver]}
      MySQL-shared-#{node[:mysql][:shared_ver]}
  }

  packages.each do |pkg|
    bash "install_rpm" do
      code <<-EOH
      if [ ! -f "#{node[:common][:archive]}/#{pkg}.rpm" ]; then
        wget -O "#{node[:common][:archive]}/#{pkg}.rpm" "#{node[:common][:host]}/#{pkg}.rpm" --no-check-certificate
      fi

      rpm -i "#{node[:common][:archive]}/#{pkg}.rpm"
      EOH
    not_if "rpm -q #{pkg}"
    end
  end
when "ubuntu","debian"
  def install_package(pkg)
    bash "install #{pkg}" do
      code <<-EOH
      if [ ! -f "#{node[:common][:archive]}/#{pkg}.deb" ]; then
        wget -O "#{node[:common][:archive]}/#{pkg}.deb" "#{node[:common][:host]}/#{pkg}.deb" --no-check-certificate
      fi

      dpkg -i "#{node[:common][:archive]}/#{pkg}.deb"
      EOH
    not_if "dpkg -l #{pkg}"
    end
  end

  %w{ mysql-common libnet-daemon-perl libplrpc-perl libdbi-perl libdbd-mysql-perl }.each do |pkg|
    package "#{pkg}" do
      action :install
    end
  end

  install_package("libmysqlclient15off_#{node[:mysql][:lib_version]}")
  install_package("mysql-client-#{node[:mysql][:client_version]}")
end
