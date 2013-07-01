package "stunnel"

case node[:platform]
when "centos","redhat","fedora"
  src = "stunnel.centos.erb"
when "ubuntu","debian"
  src = "stunnel.ubuntu.erb"
end

template "/etc/stunnel/stunnel.conf" do
  source "stunnel.conf.erb"
  mode 0644
  owner "root"
  group "root"
end

template "/etc/init.d/stunnel" do
  source "#{src}"
  mode 0755
  owner "root"
  group "root"
end

service "stunnel" do
  action :enable
end
