unless File.exists?("/usr/local/apache-ant-#{node[:ant][:version]}")
  build_bin_full "apache-ant-#{node[:ant][:version]}" do
    action :enable
    install_dest "/usr/local/apache-ant-#{node[:ant][:version]}"
    user "root"
    group "root"
    symlink "/usr/local/ant"
  end
end

template "/etc/profile.d/ant.sh" do
  source "ant.sh.erb"
  backup 0
  mode 0755
  owner "root"
  group "root"
end
