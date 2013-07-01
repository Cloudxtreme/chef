#
# Cookbook Name:: rabbitmq
# Recipe:: stage
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

include_recipe "rabbitmq"

if ! File.exists?("/usr/local/rabbitmq_server-#{node[:rabbitmq][:version]}")
  template "/usr/local/rabbitmq_server-#{node[:rabbitmq][:version]}/sbin/rabbitmq-server" do
    source "rabbitmq-server.erb"
    mode "755"
    variables ({
	:mnesia_base => "/usr/local/rabbitmq/lib/mnesia",
	:log_base => "/usr/local/rabbitmq/log",
	:node_name => "rabbit",
	:node_ip_address => "#{`/sbin/ifconfig eth0 | grep \"inet addr\" | awk '{print $2}' | cut -d ':' -f 2`}",
	:node_port => "5672",
	:cluster_config_file => "/usr/local/rabbitmq/etc/rabbitmq_cluster.config",
	:config_file => "/usr/local/rabbitmq/etc/rabbitmq",
	:pid_file => "/usr/local/rabbitmq/pids"
    })
  end

  template "/usr/local/rabbitmq/etc/rabbitmq.config" do
    source "rabbitmq.config.erb"
    owner "root"
    group "root"
    mode 0644
  end
end
