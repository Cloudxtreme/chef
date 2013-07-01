include_recipe "apache2::server"

unless File.exists?("/usr/local/apache-#{node[:apache2][:version]}/modules/mod_proxy_html.so")
  extract "mod_proxy_html" do
    action :enable
  end

  bash "Build mod_proxy_html" do
     code <<-EOH
     pushd "#{node[:common][:tmp_dir]}/mod_proxy_html" >/dev/null
     /usr/local/apache-#{node[:apache2][:version]}/bin/apxs -c -I/usr/include/libxml2 -i mod_proxy_html.c
     popd >/dev/null
     EOH
  end

  execute "Cleanup mod_proxy_html" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/mod_proxy_html"
  end
end
