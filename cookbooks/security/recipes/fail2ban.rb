unless File.exists?("/etc/fail2ban")
  extract "fail2ban-#{node[:security][:fail2ban_version]}" do
    action :enable
  end

  bash "install fail2ban" do
    code <<-EOH
      pushd "#{node[:common][:tmp_dir]}/fail2ban-#{node[:security][:fail2ban_version]}" >/dev/null
      python setup.py install
      popd >/dev/null
    EOH
  end

  execute "Cleanup fail2ban" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/fail2ban-#{node[:security][:fail2ban_version]}"
  end

end

template "/etc/fail2ban/fail2ban.conf" do
  source "fail2ban.erb"
end

template "/etc/fail2ban/jail.conf" do
  source "jail.erb"
end

template "/etc/logrotate.d/fail2ban" do
  source "fail2ban.logrotate.erb"
end

template "/etc/init.d/fail2ban" do
  source "fail2ban.init.erb"
  mode "0755"
  backup 0
end

service "fail2ban" do
  action :enable
end
