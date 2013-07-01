include_recipe "keepalived::default"

case node[:platform]
when "centos","redhat","fedora"
  path = "/etc/keepalived.conf"
when "ubuntu","debian"
  path = "/etc/keepalived/keepalived.conf"
end

template "#{path}" do
  source "keepalived.erb"
  backup 2
  variables ({
    :state => "MASTER",
    :priority => "100"
  })
end

template "/usr/local/bin/lb" do
  source "lb.erb"
  mode "0755"
  owner "root"
  group "root"
  backup 0
end
   
service "keepalived" do
  action :enable
end
