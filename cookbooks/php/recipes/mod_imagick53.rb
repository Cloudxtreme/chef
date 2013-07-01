#
# Cookbook Name:: php
# Recipe:: mod_imagick
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

include_recipe "php::php53"

unless File.exists?("#{node[:php53][:extension_dir]}/imagick.so")
  extract "imagick-#{node[:php53][:imagick_version]}" do
    action :enable
  end

  bash "PHPize imagick #{node[:php53][:imagick_version]}" do
    code <<-EOH
      pushd "#{node[:common][:tmp_dir]}/imagick-#{node[:php53][:imagick_version]}" >/dev/null
      /usr/local/php-#{node[:php53][:version]}/bin/phpize
      popd >/dev/null
    EOH
  end

  build_src "imagick-#{node[:php53][:imagick_version]}" do
    action :enable
    opts = "--with-imagick=/usr/local/ImageMagick --with-php-config=/usr/local/php-#{node[:php53][:version]}/bin/php-config"
    imagick_opts = node[:php53][:fcgi] ? opts : opts + " --with-apxs=/usr/local/apache2/bin/apxs"
    options imagick_opts
  end
 
  execute "Backup php.ini" do
    command "cp #{node[:php53][:ini_file]} #{node[:php53][:ini_file]}~"
    only_if "[ -f #{node[:php53][:ini_file]} ]"
  end


  add_line "imagick.so" do
    action :enable
    find 'extension="no-debug-non-zts-20090626/imagick.so"'
    add '/usr/local/php/lib/php/extensions/extension="no-debug-non-zts-20090626/imagick.so"'
    file "#{node[:php53][:ini_file]}"
  end

  execute "imagick Cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/imagick-#{node[:php53][:imagick_version]}"
  end
end
