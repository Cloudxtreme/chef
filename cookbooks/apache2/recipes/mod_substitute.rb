include_recipe "apache2::server"

unless File.exists?("/usr/local/apache-#{node[:apache2][:version]}/modules/mod_substitute.so")
  extract "httpd-#{node[:apache2][:version]}" do
    action :enable
  end

  bash "build mod_substitute" do
    code <<-EOH   
      pushd "#{node[:common][:tmp_dir]}/httpd-#{node[:apache2][:version]}/modules/filters" >/dev/null
      /usr/local/apache-#{node[:apache2][:version]}/bin/apxs -c -i mod_substitute.c
      popd >/dev/null
    EOH
  end 

  execute "cleanup mod_deflate" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/httpd-#{node[:apache2][:version]}"
  end
end
