unless File.exists?("/root/chkrootkit-#{node[:security][:chkrootkit_version]}")
  extract "chkrootkit-#{node[:security][:chkrootkit_version]}" do
    action :enable
  end

  build_bin_full "chkrootkit-#{node[:security][:chkrootkit_version]}" do
    action :enable
    install_dest "/root/chkrootkit-#{node[:security][:chkrootkit_version]}"
    user "root"
    group "root"
  end

  template "/etc/cron.daily/chkrootkit" do
    source "chkrootkit.erb"
    mode "0755"
    variables ({ :install_dir => "/root/chkrootkit-#{node[:security][:chkrootkit_version]}" })
  end
end
