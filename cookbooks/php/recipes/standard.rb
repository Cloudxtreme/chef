#
# Cookbook Name:: php
# Recipe:: standard
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

unless File.exists?("/usr/local/php") && File.exists?("/usr/local/php-#{node[:php][:version]}")
  build_php "php-#{node[:php][:version]}" do
    action :enable
    options "--prefix=/usr/local/php-#{node[:php][:version]} --with-apxs2=/usr/local/apache2/bin/apxs #{node[:php][:default_flags]}"
  end
end

node[:php][:fcgi] = false
