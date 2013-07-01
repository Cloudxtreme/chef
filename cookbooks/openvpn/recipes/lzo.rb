#
# Cookbook Name:: openvpn
# Recipe:: lzo
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

unless File.exists?("/usr/local/include/lzo")
  extract "lzo-#{node[:openvpn][:lzo_version]}" do
    action :enable
  end

  build_src "lzo-#{node[:openvpn][:lzo_version]}" do
    action :enable
    not_if do File.exists?("/usr/local/include/lzo") end
  end

  execute "cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/lzo-#{node[:openvpn][:lzo_version]}"
  end
end

