directory "/root/scripts" do
  owner "root"
  group "root"
  mode 0700
end

node[:scripts][:root].each do |script|
  template "/root/scripts/#{script}" do
    source "root/#{script}.erb"
    owner "root"
    group "root"
    mode 0700
  end
end
