unless File.exists?("/usr/local/bin/rkhunter")
  extract "rkhunter-#{node[:security][:rkhunter_version]}" do
    action :enable
  end

  bash "install rkhunter" do
    code <<-EOH
      pushd "#{node[:common][:tmp_dir]}/rkhunter-#{node[:security][:rkhunter_version]}" >/dev/null
      sh installer.sh --layout default --install
      popd >/dev/null
    EOH
  end

  execute "cleanup rkhunter" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/rkhunter-#{node[:security][:rkhunter_version]}"
  end

  template "/etc/cron.daily/rkhunter" do
    source "rkhunter.erb"
    mode "0755"
  end
end
