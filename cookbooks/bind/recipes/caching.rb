packages = %w{ 
  bind 
  bind-chroot
  caching-nameserver
}

packages.each do |pkg|
  package pkg do
    action :install
    not_if "rpm -q #{pkg}"
  end
end

template "/var/named/chroot/etc/named.caching-nameserver.conf" do
  source "named.caching-nameserver.conf.erb"
  mode "0640"
  owner "root"
  group "named"
end

add_line "nameserver 127.0.0.1" do
  action :enable
  find 'nameserver 127.0.0.1'
  add 'nameserver 127.0.0.1'
  file "/etc/resolv.conf"
  line '1'
end

service "named" do
  action [:enable, :start]
end
