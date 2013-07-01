unless File.exist?("/usr/local/openssh-#{node[:openssh][:version]}")
  extract "openssh-#{node[:openssh][:version]}" do
    action :enable
  end

  build_src "openssh-#{node[:openssh][:version]}" do
    action :enable
    options "--prefix=/usr/local/openssh-#{node[:openssh][:version]} --sysconfdir=/etc/ssh"
  end

 link "/usr/local/openssh" do
   to "/usr/local/openssh-#{node[:openssh][:version]}"
   not_if "[ -L /usr/local/openssh ]"
 end

  template "/etc/ssh" do
    source "openssh.erb"
    mode 0600
    owner "root"
    group "root"
  end

  execute "cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/openssh-#{node[:openssh][:version]}"
  end
end

