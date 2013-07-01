directory "/root/ganglia/gmetric" do
  owner "root"
  group "root"
  mode 0700
  recursive true
end

node[:ganglia][:gmetric][:scripts].each do |script|
  template "/root/ganglia/gmetric/#{script}" do
    source "gmetric/#{script}.erb"
    owner "root"
    group "root"
    mode 0700    
  end
end
