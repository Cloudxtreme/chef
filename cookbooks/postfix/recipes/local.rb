node[:postfix][:transport_maps] = [ "example.com smtp:[10.0.1.1]" ]
node[:postfix][:catch-all] = "catch-all@example.com"

group "postfix" do
  gid 3000
end

group "postdrop" do
  gid 3001
end

user "postfix" do
  gid "postfix"
  uid 3000
  home "/home/postfix"
  supports :manage_home => false
  shell "/bin/bash"
end

%w{ db4-devel sendmail }.each do |pkg|
  package pkg do
    action :install
  end
end

service "sendmail" do
  action :disable
end

directory "/usr/local/postfix-local/etc" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
end

template "/usr/local/postfix-local/etc/main.cf" do
  source "main.cf.local.erb"
end

unless File.exists?("/usr/local/postfix-local/sbin/postfix")
  extract "postfix-#{node[:postfix][:version]}" do
    action :enable
  end

  cookbook_file "#{node[:common][:tmp_dir]}/postfix-#{node[:postfix][:version]}/make.local.sh" do
    source "make.local.sh"
  end

  bash "build local postfixes" do
    code <<-EOH
      pushd "#{node[:common][:tmp_dir]}/postfix-#{node[:postfix][:version]}" >/dev/null
      sh make.local.sh
      popd >/dev/null
    EOH
    not_if "[ -f /usr/local/postfix-local/sbin/postfix ]"
  end

  execute "postfix cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/postfix-#{node[:postfix][:version]}"
  end
end

[ "virtual", "transport" ].each do |file|
  template "/usr/local/postfix-local/etc/#{file}" do
    source "#{file}.erb"
    mode "0644"
    owner "root"
    group "root"
  end

  execute "hash #{file}" do
    command "/usr/local/postfix-local/sbin/postmap /usr/local/postfix-local/etc/#{file}"
    only_if "[ ! -f /usr/local/postfix-local/etc/#{file}.db ]||[ /usr/local/postfix-local/etc/#{file} -nt /usr/local/postfix-local/etc/#{file}.db ]"
  end
end
