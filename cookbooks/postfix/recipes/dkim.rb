#
# Cookbook Name:: postfix
# Recipe:: dkim
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

# install tcsh
package "tcsh" do
  action :install
end

case node[:platform]
when "centos","redhat","fedora"
  name = "dkim-milter"

  install_rpm "dkim-milter-#{node[:postfix][:dkim_version]}" do
    action :enable
    k "dkim-milter"
    v "dkim-milter-#{node[:postfix][:dkim_version]}"
  end
when "ubuntu","debian"
  name = "dkim-filter"

  package name do
    action :install
  end
end

service name do
  pattern "dkim-filter"
  action :enable
end

