node[:apache2][:dir] = "/usr/local/apache-#{node[:apache2][:version]}"

unless File.exist?("/usr/local/apache-#{node[:apache2][:version]}")
  extract "httpd-#{node[:apache2][:version]}" do
    action :enable
  end

  bash "buildconf" do
    code <<-EOH
      pushd #{node[:common][:tmp_dir]}/httpd-#{node[:apache2][:version]} >/dev/null
      ./buildconf
      popd >/dev/null
    EOH
  end

  cookbook_file "#{node[:common][:tmp_dir]}/apache-#{node[:apache2][:version]}-server-header.patch" do
    source "apache-#{node[:apache2][:version]}-server-header.patch"
  end

  bash "patch server header" do
    code <<-EOH
      pushd #{node[:common][:tmp_dir]}/httpd-#{node[:apache2][:version]} >/dev/null && \
      patch -p0 < #{node[:common][:tmp_dir]}/apache-#{node[:apache2][:version]}-server-header.patch && \
      popd >/dev/null
    EOH
    only_if "[ -f #{node[:common][:tmp_dir]}/apache-#{node[:apache2][:version]}-server-header.patch ]"
  end

  build_src "httpd-#{node[:apache2][:version]}" do
    action :enable
    options "--prefix=/usr/local/apache-#{node[:apache2][:version]} --enable-so --enable-rewrite --enable-proxy \
          --enable-proxy-http --enable-ssl --enable-headers --with-mpm=#{node[:apache2][:mpm]}"
    not_if "[ -d /usr/local/apache-#{node[:apache2][:version]} ]"
  end

  execute "cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/httpd-#{node[:apache2][:version]}"
  end
end

# These should always exist
template "/usr/local/apache-#{node[:apache2][:version]}/bin/apachectl" do
  source "apachectl.erb"
  mode 0755
  owner "root"
  group "root"
end

link "/usr/local/apache2" do
  to "/usr/local/apache-#{node[:apache2][:version]}"
  not_if "[ -L /usr/local/apache2 ]"
end

link "/etc/init.d/apachectl" do
  to "/usr/local/apache2/bin/apachectl"
  not_if "[ -L /etc/init.d/apachectl ]"
end

service "apachectl" do
  action :enable
end

directory "/cores" do
  owner "root"
  group "root"
  mode "0777"
end

directory "/web" do
  owner "builder"
  group "builder"
  mode "0775"
end
