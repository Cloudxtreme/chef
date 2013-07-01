include_recipe "gems::mail"

template "/root/scripts/maillog.rb" do
  source "maillog.rb.erb"
  mode "0755"
  group "root"
  owner "root"
end

template "/etc/init.d/maillog" do
  source "maillog.init.erb"
  mode "0755"
  group "root"
  owner "root"
end

service "maillog" do
  action :enable
end
