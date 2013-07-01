include_recipe "ganglia::client"
include_recipe "perl::file-tail"

template "/usr/bin/mailgraph.pl" do
  source "mailgraph.pl.erb"
  mode "0755"
  group "root"
  owner "root"
end

template "/etc/init.d/mailgraph" do
  source "mailgraph.init.erb"
  mode "0755"
  group "root"
  owner "root"
end

service "mailgraph" do
  action :enable
end
