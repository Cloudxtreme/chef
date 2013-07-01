case node[:platform]
when "ubuntu","debian"
  execute "request percona key" do
#    command "gpg --keyserver pool.sks-keyservers.net --recv-keys 1C4CBDCDCD2EFD2A"
    command "gpg --recv-keys 1C4CBDCDCD2EFD2A"
    not_if "gpg --list-keys CD2EFD2A"
  end 

  execute "install percona key" do
    command "gpg -a --export CD2EFD2A | apt-key add -"
    not_if "apt-key list | grep CD2EFD2A"
  end

  template "/etc/apt/sources.list.d/percona.list"

  execute "update apt" do
    command "apt-get update"
    subscribes :run, resources(:template => "/etc/apt/sources.list.d/percona.list"), :immediately
    action :nothing
  end

  package "percona-server-client"
  package "libmysqlclient-dev"
when "redhat","centos","fedora"
  case node[:kernel][:machine]
  when "x86_64"
    url = "http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm"
    kernel = "x86_64"
  when "i686"
    url = "http://www.percona.com/downloads/percona-release/percona-release-0.0-1.i386.rpm"
    kernel = "i386"
  end

  execute "install percona repo" do
    command "rpm -Uvh #{url}"
    creates "/etc/yum.repos.d/Percona.repo"
  end

  package "Percona-Server-client-#{node[:mysql][:percona][:rpm_version]}"
  package "Percona-Server-devel-#{node[:mysql][:percona][:rpm_version]}"
end
