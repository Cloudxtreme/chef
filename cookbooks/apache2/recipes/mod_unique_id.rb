include_recipe "apache2::server"

unless File.exists?("/usr/local/apache-#{node[:apache2][:version]}/modules/mod_unique_id.so")
  extract "httpd-#{node[:apache2][:version]}" do
    action :enable
  end

  bash "Build mod_unique_id" do
    code <<-EOH   
      pushd "#{node[:common][:tmp_dir]}/httpd-#{node[:apache2][:version]}/modules/metadata" >/dev/null
      /usr/local/apache-#{node[:apache2][:version]}/bin/apxs -c -i mod_unique_id.c
      popd >/dev/null
    EOH
  end 

  execute "Cleanup mod_deflate" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/httpd-#{node[:apache2][:version]}"
  end
end
