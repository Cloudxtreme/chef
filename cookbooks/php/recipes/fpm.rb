#
# Cookbook Name:: php
# Recipe:: fpm
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
unless File.exists?("/usr/local/php-#{node[:php][:version]}")
  build_php "php-#{node[:php][:version]}" do
    action :enable
    options "--prefix=/usr/local/php-#{node[:php][:version]} #{node[:php][:fcgi_flags]} #{node[:php][:default_flags]} --enable-fpm"
    fpm "yes"
  end
end

template "/usr/local/php-#{node[:php][:version]}/etc/php-fpm.conf" do
    source "php-fpm.#{node[:php][:version]}.erb"
end

template "/etc/init.d/php-fpm" do
  source "php-fpm.init.erb"
  owner "root"
  group "root"
  mode 0755
end

execute "touch phpfcgi" do
  command "touch /usr/local/apache2/cgi-bin/phpfcgi"
  not_if "[ -f /usr/local/apache2/cgi-bin/phpfcgi ]"
end

service "php-fpm" do
  pattern "php-cgi"
  action :enable
end

node[:php][:fcgi]
