#
# Cookbook Name:: php
# Recipe:: php53
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

node[:php53][:install_flags] = "--prefix=/usr/local/php-#{node[:php53][:version]} --with-mysql=/usr/local/mysql --with-config-file-path=/usr/local/php-#{node[:php53][:version]}/etc --with-openssl --with-curl --enable-mbstring --enable-fpm"
node[:php53][:install_dir] = "/usr/local/php-#{node[:php53][:version]}"


unless File.exists?("/usr/local/php-#{node[:php53][:version]}")
  build_php53 "php-#{node[:php53][:version]}" do
    action :enable
    install_options node[:php53][:install_flags]
  end
end

template "/usr/local/php-#{node[:php53][:version]}/etc/php-fpm.conf" do
  source "php53-fpm.conf.erb"
end

template "/usr/local/php-#{node[:php53][:version]}/etc/php.ini" do
  source "php53.ini.erb"
end

link "/usr/local/php" do
  to "/usr/local/php-#{node[:php53][:version]}"
  not_if "[ -L /usr/local/php ]"
end

template "/etc/init.d/php-fpm" do
  source "php-fpm53.init.erb"
  owner "root"
  group "root"
  mode 0755
end


service "php53-fpm" do
  pattern "php-fpm"
  action :enable
end
