packages = %w{ 
  libpcap 
  libpcap-devel 
}

packages.each do |pkg|
  package pkg do
    action :install
    not_if "rpm -q #{pkg}"   
  end
end

unless File.exists?("/usr/local/knockd-#{node[:knockd][:version]}")
  extract "knock-#{node[:knockd][:version]}" do
    action :enable
  end

  build_src "knock-#{node[:knockd][:version]}" do
    action :enable
    options "--prefix=/usr/local/knockd-#{node[:knockd][:version]}"
  end

  execute "cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/knock-#{node[:knockd][:version]}"
  end
end

template "/etc/knockd.conf" do
  source "knockd.conf.#{node[:knockd][:config]}.erb"
end

link "/usr/local/knockd" do
  to "/usr/local/knockd-#{node[:knockd][:version]}"
  not_if "[ -L /usr/local/knockd ]"
end

template "/etc/init.d/knockd" do
  source "knockd.init.erb"
  backup 0
  mode "0755"
  owner "root"
  group "root"
end

execute "Add knockd to chkconfig" do
  command "/sbin/chkconfig --add knockd"
  not_if "/sbin/chkconfig --list | grep 'knockd.*3:on'"
end
