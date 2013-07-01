#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2010, Example Com
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

if ! File.exists?("/usr/local/rabbitmq_server-#{node[:rabbitmq][:version]}")
  group "rabbitmq" do
    gid 2023
  end

  user "rabbitmq" do
    uid 2023
    gid 2023
    home "/home/rabbitmq"
    shell "/bin/bash"
  end

  extract "rabbitmq_server-#{node[:rabbitmq][:version]}" do
    action :enable
  end

  build_bin_full "rabbitmq_server-#{node[:rabbitmq][:version]}" do
    action :enable
    install_dest "/usr/local/rabbitmq_server-#{node[:rabbitmq][:version]}"
    user "rabbitmq"
    group "rabbitmq"
    symlink "/usr/local/rabbitmq"
    if File.exists?("/usr/local/rabbitmq_server-#{node[:rabbitmq][:version]}")
      exit
    end
  end

  bash "mkdirs for rabbitmq" do
    code <<-EOH
      mkdir -p /usr/local/rabbitmq/log /usr/local/rabbitmq/lib/mnesia /usr/local/rabbitmq/etc
      chown -R rabbitmq.rabbitmq /usr/local/rabbitmq/log /usr/local/rabbitmq/lib /usr/local/rabbitmq/etc
    EOH
  end

  template "/etc/init.d/rabbitmq-server" do
    mode 0755
    source "rabbitmq-init.d.erb"
    not_if do File.exists?("/etc/init.d/rabbitmq-server") end
  end

  execute "Cleanup rabbitmq" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/rabbitmq_server-#{node[:rabbitmq][:version]}"
  end
end
