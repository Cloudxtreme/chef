case node[:platform]
when "centos","redhat","fedora"
  unless File.exist?("/usr/local/haproxy-#{node[:haproxy][:version]}")
    extract "haproxy-#{node[:haproxy][:version]}" do
      action :enable
    end

    %w{ sbin etc chroot }.each do |dir|
      directory "/usr/local/haproxy-#{node[:haproxy][:version]}/#{dir}" do
        owner "root"
        group "root"
        mode "0755"
        recursive true
      end
    end

    bash "build haproxy" do
      code <<-EOH
        pushd "#{node[:common][:tmp_dir]}/haproxy-#{node[:haproxy][:version]}" >/dev/null
        make TARGET=linux26 ARCH=i386
        make install DESTDIR="/usr/local/haproxy-#{node[:haproxy][:version]}" PREFIX=
        popd >/dev/null
      EOH
    end

    execute "cleanup" do
      command "/bin/rm -rf #{node[:common][:tmp_dir]}/haproxy-#{node[:haproxy][:version]}"
    end
  end

  link "/usr/local/haproxy" do
    to "/usr/local/haproxy-#{node[:haproxy][:version]}"
    not_if "[ -L /usr/local/haproxy ]"
  end
  
  template "/etc/init.d/haproxy" do
    source "haproxy.init.erb"
    owner "root"
    group "root"
    mode 0755
  end

  template "/usr/local/haproxy-#{node[:haproxy][:version]}/etc/haproxy.cfg" do
    source "#{node[:haproxy][:template]}.haproxy.cfg.erb"
    mode "0644"
    owner "root"
    group "root"
  end

  service "haproxy" do
    action :enable
  end
when "ubuntu","debian"
  package "haproxy"

  directory "/usr/share/haproxy" do
    mode "0755"
    owner "haproxy"
    group "haproxy"
  end
 
  template "/etc/haproxy/haproxy.cfg" do
    source "#{node[:haproxy][:template]}.haproxy.cfg.erb"
    mode "0644"
    owner "root"
    group "root"
  end

  template "/etc/default/haproxy" do
    notifies :restart, "service[haproxy]"
    source "haproxy.default.erb"
    mode "0644"
    owner "root"
    group "root"
  end

  service "haproxy" do 
    supports :restart => true
    action [ :enable, :start ]
  end
end
