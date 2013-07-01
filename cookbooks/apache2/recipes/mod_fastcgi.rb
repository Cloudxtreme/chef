include_recipe "apache2::server"

unless File.exists?("/usr/local/apache-#{node[:apache2][:version]}/modules/mod_fastcgi.so")
  extract "mod_fastcgi-#{node[:apache2][:mod_fastcgi_version]}" do
    action :enable
  end

  bash "Build mod_fastcgi" do
    code <<-EOH   
      pushd "#{node[:common][:tmp_dir]}/mod_fastcgi-#{node[:apache2][:mod_fastcgi_version]}" >/dev/null
      /usr/local/apache-#{node[:apache2][:version]}/bin/apxs -o mod_fastcgi.so -c *.c
      pushd .libs >/dev/null
      /usr/local/apache-#{node[:apache2][:version]}/bin/apxs -i -a -n fastcgi mod_fastcgi.so
      popd >/dev/null
      popd >/dev/null
    EOH
  end 

  cookbook_file "/usr/local/apache-#{node[:apache2][:version]}/cgi-bin/php5.fcgi" do
    source "php5.fcgi"
    mode "0644"
  end

  execute "touch fcgi" do
    command "touch /usr/local/apache-#{node[:apache2][:version]}/cgi-bin/phpfcgi"
    not_if "[ -f /usr/local/apache-#{node[:apache2][:version]}/cgi-bin/phpfcgi ]"
  end

  execute "Cleanup mod_fastcgi" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/mod_fastcgi-#{node[:apache2][:mod_fastcgi_version]}"
  end
end
