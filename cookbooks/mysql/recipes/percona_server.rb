#
# Cookbook Name:: mysql
# Recipe:: percona
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

include_recipe "mysql::percona_client"

case node[:platform]
when "ubuntu", "debian"
  package "libaio1"
end

group "mysql" do
  gid 2003
end

user "mysql" do
  uid 2003
  gid 2003
  home "/home/mysql"
  shell "/bin/bash"
end

unless File.exists?("#{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]}")
  extract "Percona-Server-#{node[:mysql][:percona][:version]}" do
    action :enable
  end

  build_bin "Percona-Server-#{node[:mysql][:percona][:version]}" do
    action :enable
    install_dir "#{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]}"
  end

  bash "mysql initial config" do
    code <<-EOH
      pushd "#{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]}" >/dev/null

      export PATH=#{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]}/bin:$PATH
      sudo ./scripts/mysql_install_db --user=mysql --basedir=#{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]} \
	--datadir=#{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]}/data
      sudo chown -R root  .
      sudo chown -R mysql data
      sudo chgrp -R mysql .

      ./support-files/mysql.server start --basedir=#{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]} \ 
	 --datadir=#{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]}/data
      ./bin/mysqladmin -uroot password $(hostname)
      ./support-files/mysql.server stop --basedir=#{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]} \
         --datadir=#{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]}/data
      /bin/rm -rf #{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]}/data/ib_logfile*
      popd >/dev/null
    EOH
    not_if "[ -f #{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]}/data/ibdata1 ]"
  end
end

link "/usr/local/mysql" do
  to "#{node[:mysql][:install_dir]}/Percona-Server-#{node[:mysql][:percona][:version]}"
  not_if "[ -L /usr/local/mysql ]"
end

link "/etc/init.d/mysql.server" do
  to "/usr/local/mysql/support-files/mysql.server"
  not_if "[ -f /etc/init.d/mysql.server ]"
end

template "/etc/profile.d/mysql.sh" do
  source "mysql.sh.erb"
  backup 0
  mode 0755
  owner "root"
  group "root"
end

template "/etc/my.cnf" do
  source "percona.my.cnf.erb"
  mode 0600
  owner "root"
  group "root"
end

service "mysql.server" do
  action :enable
end
