case node[:platform]
when "redhat","centos","fedora"
  package "iptables" do
    action :install
    not_if "rpm -q iptables"
  end

  template "/etc/sysconfig/iptables" do
    notifies :restart, "service[iptables]"
    source "#{node[:iptables][:location]}/#{node[:iptables][:role]}.erb"
    mode 0600
    owner "root"
    group "root"
    only_if { node[:iptables][:overwrite] }
  end
when "ubuntu","debian"
  package "iptables" do
    action :install
    not_if "dpkg -l iptables"
  end
  
  template "/etc/init.d/iptables" do
    source "iptables.init.d.erb"
    mode 0755
    owner "root"
    group "root"
  end

  template "/etc/default/iptables" do
    notifies :restart, "service[iptables]"
    source "#{node[:iptables][:location]}/#{node[:iptables][:role]}.erb"
  end
end

service "iptables" do
  supports :restart => true
  action [ :enable, :start ]
end

