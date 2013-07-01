include_recipe "gems::fluentd_rvm_192"

group "fluent" do
  gid 3000
end

user "fluent" do
  uid 3000
  gid 3000
  home node[:fluent][:log_dir]
  shell "/bin/bash"
end

directory "/etc/fluent" do
  owner "root"
  group "root"
  mode 0755
end

directory node[:fluent][:log_dir] do
  owner "root"
  group "fluent"
  mode 0775
end

link node[:fluent][:log_link_dir] do
  to node[:fluent][:log_dir]
  only_if do
    node[:fluent][:log_link_dir].size > 0
  end
end

template "/etc/fluent/fluent.conf" do
  notifies :restart, "service[fluentd]"
  source "fluent.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "/etc/init.d/fluentd" do
  source "fluent.init.erb"
  owner "root"
  group "root"
  mode 0755
end

service "fluentd" do
  supports :restart => true
  action [:enable, :start]
end
