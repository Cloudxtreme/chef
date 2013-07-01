include_recipe "ruby::ree"

template "/etc/profile.d/ruby.sh" do
  source "ruby.sh.erb"
  backup 0
  mode 0755
  owner "root"
  group "root"
end
