#
# Cookbook Name:: postfix
# Recipe:: dk
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
  name = "dk-milter"
 
  install_rpm "dk-milter-#{node[:postfix][:dk_version]}" do
    action :enable
    k "dk-milter"
    v "dk-milter-#{node[:postfix][:dk_version]}"
  end
when "ubuntu", "debian"
  name = "dk-filter"

  package name do
    action :install
  end
end

service name do
  pattern "dk-filter"
  action :enable
end

# to replace
# from:		if [[ ! -z $(echo $PORT |grep "local") && $RETVAL -eq 0  ]]; then
# to:		if [[ -z $(echo $PORT |grep "inet") && $RETVAL -eq 0  ]]; then
