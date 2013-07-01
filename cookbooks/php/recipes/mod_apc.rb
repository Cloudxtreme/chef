#
# Cookbook Name:: php
# Recipe:: mod_apc
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
include_recipe "php"

unless File.exists?("#{node[:php][:extension_dir]}/apc.so")
  extract "APC-#{node[:php][:apc_version]}" do
    action :enable
  end

  bash "PHPize APC #{node[:php][:apc_version]}" do
    code <<-EOH
      pushd "#{node[:common][:tmp_dir]}/APC-#{node[:php][:apc_version]}" >/dev/null
      /usr/local/php-#{node[:php][:version]}/bin/phpize
      popd >/dev/null
    EOH
  end

  build_src "APC-#{node[:php][:apc_version]}" do
    action :enable

    opts = "--enable-apc --enable-apc-mmap --with-php-config=/usr/local/php-#{node[:php][:version]}/bin/php-config"
    apc_opts = node[:php][:fcgi] ? opts : opts + " --with-apxs=/usr/local/apache2/bin/apxs"
    options apc_opts
  end
 
  execute "backup php.ini" do
    command "cp #{node[:php][:ini_file]} #{node[:php][:ini_file]}~"
    only_if "[ -f #{node[:php][:ini_file]} ]"
  end

  add_line "apc.so" do
    action :enable
    find 'extension="no-debug-non-zts-20060613/apc.so"'
    add 'extension="no-debug-non-zts-20060613/apc.so"'
    file "#{node[:php][:ini_file]}"
  end

  add_line "apc shm_size" do
    action :enable
    find 'apc.shm_size ='
    add 'apc.shm_size = 64'
    file "#{node[:php][:ini_file]}"
  end

  execute "APC Cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/APC-#{node[:php][:apc_version]}"
  end
end
