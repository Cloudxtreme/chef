unless File.exists?("/usr/local/monit-#{node[:monit][:version]}")
  extract "monit-#{node[:monit][:version]}" do
    action :enable
  end

  build_src "monit-#{node[:monit][:version]}" do
    action :enable
    options "--prefix=/usr/local/monit-#{node[:monit][:version]}"
    not_if "[ -d /usr/local/monit-#{node[:monit][:version]} ]"
  end

  execute "cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/monit-#{node[:monit][:version]}"
  end
end

# always run

directory "/etc/monit.d" do
  mode "0755"
  owner "root"
  group "root"
end

link "/usr/local/monit" do
  to "/usr/local/monit-#{node[:monit][:version]}"
  not_if "[ -L /usr/local/monit ]"
end

template "/etc/init.d/monit" do
  source "monit.init.erb"
  mode "0755"
  owner "root"
  group "root"
  backup 0
end

service "monit" do
  supports :reload => true
  action :enable
end

