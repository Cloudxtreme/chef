case node[:platform]
when "ubuntu","debian"
  package "gmetad"
when "redhat","centos","fedora"
  case node[:kernel][:machine]
  when "x86_64"
    url = "http://dl.fedoraproject.org/pub/epel/5Server/x86_64/epel-release-5-4.noarch.rpm"
  when "i686"
    url = "http://dl.fedoraproject.org/pub/epel/5Server/i386/epel-release-5-4.noarch.rpm"
  end

  case node[:platform_version].split(".").first.to_i
  when 6
    expat = "compat-expat1"
  else
    expat = "expat"
  end

  execute "install epel repo" do
    command "rpm -Uvh #{url}"
    creates "/etc/yum.repos.d/epel.repo"
  end

  yum_package "rrdtool" do
    options "--enablerepo=epel"
    version "1.2.27-3.el5"
  end 

  package expat

  [
    "libconfuse-#{node[:ganglia][:libconfuse][:version]}",
    "libganglia-#{node[:ganglia][:libganglia][:version]}",
  ].each do |pkg|
    install_rpm "#{pkg}.#{node[:ganglia][:arch]}" do
      action :enable
      k pkg
      v "#{pkg}.#{node[:ganglia][:arch]}"
    end
  end

  install_rpm "ganglia-gmetad-#{node[:ganglia][:gmetad][:version]}.#{node[:ganglia][:arch]}" do
    action :enable
    k "ganglia-gmetad"
    v "ganglia-gmetad-#{node[:ganglia][:gmetad][:version]}.#{node[:ganglia][:arch]}"
  end
end

directory "/var/lib/ganglia/rrds" do
  recursive true
  owner "nobody"
#  group "ganglia"
  mode 0755
end

template "/etc/ganglia/gmetad.conf" do
  source "gmetad.conf.erb"
  notifies :restart, "service[gmetad]"
end

service "gmetad" do
  supports :restart => true
  action [ :enable, :start ]
end
