if ! File.exists?("/usr/local/ruby/bin/dbi")
  extract "dbi-#{node[:gems][:dbi_version]}" do
    action :enable
  end

  bash "Build dbi-#{node[:gems][:dbi_version]}" do
    code <<-EOH
    pushd "#{node[:common][:tmp_dir]}/dbi-#{node[:gems][:dbi_version]}"
    /usr/local/ruby/bin/ruby setup.rb all
    popd
    EOH
  end

  execute "Cleanup dbi-#{node[:gems][:dbi_version]}" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/dbi-#{node[:gems][:dbi_version]}"
  end
end
