directory "#{node[:common][:archive]}" do
  owner "root"
  group "root"
  mode "0755"
end

directory "/root/scripts" do
  mode "0700"
  owner "root"
  group "root"
end
