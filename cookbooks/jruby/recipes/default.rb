unless File.exists?("/usr/local/jruby-#{node[:jruby][:version]}")
  build_bin_full "jruby-#{node[:jruby][:version]}" do
    action :enable
    install_dest "/usr/local/jruby-#{node[:jruby][:version]}"
    user "root"
    group "root"
    symlink "/usr/local/jruby"
  end
end

template "/etc/profile.d/jruby.sh" do
  source "jruby.sh.erb"
  backup 0
  mode 0755
  owner "root"
  group "root"
end
