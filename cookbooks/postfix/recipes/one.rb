unless File.exists?("/usr/local/postfix1/sbin/postfix")
  node[:postfix1][:syslog_name] = "postfix-" + %x[/sbin/ifconfig #{node[:postfix1][:interface]}|grep 'inet addr'][/^.+addr:([^ ]+) /,1]

  package "db4-devel" do
    action :install
  end

  extract "postfix-#{node[:postfix][:version]}" do
    action :enable
  end

  execute "mkdir /usr/local/postfix1/etc" do
    command "mkdir -p /usr/local/postfix1/etc"
    not_if "[ -d /usr/local/postfix1/etc ]"
  end

  template "/usr/local/postfix1/etc/main.cf" do
    source "main.cf.one.erb"
    not_if "[ -f /usr/local/postfix1/etc/main.cf ]"
  end

  cookbook_file "#{node[:common][:tmp_dir]}/postfix-#{node[:postfix][:version]}/make.sh" do
    source "make.sh"
  end

  bash "build postfix1" do
    code <<-EOH
      pushd "#{node[:common][:tmp_dir]}/postfix-#{node[:postfix][:version]}" >/dev/null
      sh make.sh 1
      popd >/dev/null
    EOH
    not_if "[ -f /usr/local/postfix1/sbin/postfix ]"
  end

  execute "change postfix1 port to #{node[:postfix1][:port]}" do
    command "sed -i 's@^smtp\b\s\+\binet@#{node[:postfix1][:port]}\t  inet@' /usr/local/postfix1/etc/master.cf"
    not_if "egrep -q '^#{node[:postfix1][:port]}\s+\binet\b' /usr/local/postfix1/etc/master.cf"
  end

  execute "postfix cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/postfix-#{node[:postfix][:version]}"
  end
end
