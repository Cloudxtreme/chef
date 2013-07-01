include_recipe "monit"

# default app template

template "/etc/monitrc" do
  notifies :reload, "service[monit]"
  source "app.monitrc.erb"
  mode "0700"
end

# app specific services

node[:monit][:services][:app].each do |service|
  template "/etc/monit.d/#{service}" do
    notifies :reload, "service[monit]"
    source "#{service}.erb"
    backup 0
    mode "0700"
    owner "root"
    group "root"
  end
end

node[:monit][:services2][:app].each do |service,details|
  template "/etc/monit.d/#{service}" do
    notifies :reload, "service[monit]"
    source "#{details[:template]}.erb"
    mode "0700"
    backup 0
    owner "root"
    group "root"
    variables ({
        :app => service,
        :conn_host => details[:conn_host],
        :conn_port => details[:conn_port]
    })
  end
end

service "monit" do
  supports :reload => true
  action node[:monit][:actions]
end

