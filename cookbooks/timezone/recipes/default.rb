#
# Cookbook Name:: timezone
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when "centos","redhat","fedora"
  template "/etc/sysconfig/clock" do
    source "clock.erb"
    mode 0644
    owner "root"
    group "root"
  end
when "ubuntu","debian"
  template "/etc/timezone" do
    source "timezone.erb"
    mode 0644
    owner "root"
    group "root"
  end
end

link "/etc/localtime" do
  to "/usr/share/zoneinfo/#{node[:timezone][:zone]}"
  only_if "[ -f /usr/share/zoneinfo/#{node[:timezone][:zone]} ]"
end
