include_recipe "asterisk::dahdi"

if ! File.exists?("/usr/local/asterisk")

packages = %w{
    gtk+
    gtk+-devel
    sox
    sox-devel
    ncurses
    ncurses-devel
    openssl
    openssl-devel
    zlib
    zlib-devel
    bison
    bison-devel
    newt
    newt-devel
  }

modules = %w{
    DBI::DBD
    Term::Readkey
    Net::LDAP
    Net::LDAP::Control
  }

modules.each do |mod|
  `perl -MCPAN -e 'install #{mod}'`
end

packages.each do |pkg|
  `rpm -q #{pkg}`
  if ! $?.exitstatus.zero?
    package pkg do
      action :install
    end
  end
end

extract "asterisk-#{node[:asterisk][:version]}" do
  action :enable
end

build_src "asterisk-#{node[:asterisk][:version]}" do
  action :enable
  options "--prefix=/usr/local/asterisk-#{node[:asterisk][:version]}"
  if File.exists?("#{node[:asterisk][:dir]}")
    exit
  end
end

link "/usr/local/asterisk" do
  to "/usr/local/asterisk-#{node[:asterisk][:version]}"
end

template "/etc/init.d/asterisk" do
  source "asterisk.erb"
  mode "755"
  not_if do File.exists?("/etc/init.d/asterisk") end
end

template "/usr/local/asterisk/sbin/forgot-vkey" do
  source "forgot-vkey.erb"
  mode "755"
  not_if do File.exists?("/usr/local/asterisk/sbin/forgot-vkey") end
end

template "/usr/local/asterisk/sbin/dnd" do
  source "dnd.erb"
  mode "755"
  not_if do File.exists?("/usr/local/asterisk/sbin/dnd") end
end

execute "add asterisk to chkconfig" do
  command "/sbin/chkconfig --add asterisk"
  action :run
end

execute "cleanup" do
  command "/bin/rm -rf #{node[:common][:tmp_dir]}/asterisk-#{node[:asterisk][:version]}"
  action :run
end

include_recipe "asterisk::sounds"

end
