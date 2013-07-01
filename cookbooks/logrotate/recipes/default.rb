case node[:platform]
when "redhat","centos","fedora"
  package "logrotate" do
    action :install
    not_if "rpm -q logrotate"
  end
when "ubuntu","debian"
  package "logrotate" do
    action :install
    not_if "dpkg -l logrotate"
  end
end

template "/etc/logrotate.conf" do
  source "logrotate.conf.erb"
  mode 0644
  owner "root"
  group "root"
end

template "/etc/cron.daily/logrotate" do
  source "logrotate.cron.erb"
  backup 0
  mode 0755
  owner "root"
  group "root"
end

node[:logrotate][:services].each_key do |service|
  template "/etc/logrotate.d/#{service}" do
    source "service.erb"
    backup 0
    mode 0644
    owner "root"
    group "root"
    variables ({ :service => service })
  end
end
