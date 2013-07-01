#
unless File.exist?("/usr/local/lighttpd-#{node[:lighttpd][:version]}")
  extract "lighttpd-#{node[:lighttpd][:version]}" do
    action :enable
  end

  build_src "lighttpd-#{node[:lighttpd][:version]}" do
    action :enable
    options "--prefix=/usr/local/lighttpd-#{node[:lighttpd][:version]} --with-openssl"
  end

  execute "cleanup lighttpd-#{node[:lighttpd][:version]}" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/lighttpd-#{node[:lighttpd][:version]}"
  end
end

link "/usr/local/lighttpd" do
  to "/usr/local/lighttpd-#{node[:lighttpd][:version]}"
  not_if "[ -L /usr/local/lighttpd ]"
end

template "/etc/init.d/lighttpd" do
  source "lighttpd.init.erb"
  mode 0755 
  owner "root"
  group "root"
end
