if ! File.exists?("/usr/local/ruby/lib/ruby/site_ruby/1.8/dbd")
  extract "dbd-mysql-#{node[:gems][:dbd_version]}" do
    action :enable
  end

  bash "Build dbd-mysql-#{node[:gems][:dbd_version]}" do
    code <<-EOH
    pushd "#{node[:common][:tmp_dir]}/dbd-mysql-#{node[:gems][:dbd_version]}"
    /usr/local/ruby/bin/ruby setup.rb all
    popd
    EOH
  end

  execute "Cleanup dbd-mysql-#{node[:gems][:dbd_version]}" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/dbd-mysql-#{node[:gems][:dbd_version]}"
  end
end
