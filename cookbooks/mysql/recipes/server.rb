#
# Cookbook Name:: mysql
# Recipe:: server
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

group "mysql" do
  gid 2003
end

user "mysql" do
  uid 2003
  gid 2003
  home "/home/mysql"
  shell "/bin/bash"
end

unless File.exists?("#{node[:mysql][:install_dir]}/mysql-#{node[:mysql][:version]}")
  extract "mysql-#{node[:mysql][:version]}" do
    action :enable
  end

  build_bin "mysql-#{node[:mysql][:version]}" do
    action :enable
    install_dir "#{node[:mysql][:install_dir]}/mysql-#{node[:mysql][:version]}"
  end

  bash "mysql initial config" do
    code <<-EOH
      pushd "#{node[:mysql][:install_dir]}/mysql-#{node[:mysql][:version]}" >/dev/null

      export PATH=/usr/local/mysql/bin:$PATH
      sudo ./scripts/mysql_install_db --user=mysql
      sudo chown -R root  .
      sudo chown -R mysql data
      sudo chgrp -R mysql .

      ./support-files/mysql.server start
      ./bin/mysqladmin -uroot password $(hostname)
      ./support-files/mysql.server stop

      /bin/rm -rf #{node[:mysql][:install_dir]}/mysql-#{node[:mysql][:version]}/data/ib_logfile*
      popd >/dev/null
    EOH
    not_if "[ -f #{node[:mysql][:install_dir]}/mysql-#{node[:mysql][:version]}/data/ibdata1 ]"
  end
end

link "/usr/local/mysql" do
  to "#{node[:mysql][:install_dir]}/mysql-#{node[:mysql][:version]}"
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

service "mysql.server" do
  action :enable
  only_if do node[:mysql][:server][:enable] end
end
