include_recipe "scripts::root"

directory "/root/scripts/functions" do
  owner "root"
  group "root"
  mode 0700
end

template "/root/scripts/funcs.sh" do
  source "funcs.sh.erb"
  owner "root"
  group "root"
  mode 0700
end

node[:scripts][:functions][:root].each do |script|
  template "/root/scripts/functions/#{script}" do
    source "root/functions/#{script}.erb"
    owner "root"
    group "root"
    mode 0700
  end
end
