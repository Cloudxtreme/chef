include_recipe "apache2::server"
include_recipe "apache2::mod_unique_id"
include_recipe "lua::lib"

unless File.exists?("/usr/local/apache-#{node[:apache2][:version]}/modules/mod_security2.so")
  extract "modsecurity-apache_#{node[:apache2][:mod_security_version]}" do
    action :enable
  end

  build_src "modsecurity-apache_#{node[:apache2][:mod_security_version]}/apache2" do
    action :enable
    options "--with-apxs=/usr/local/apache-#{node[:apache2][:version]}/bin/apxs --with-apr=/usr/local/apache-#{node[:apache2][:version]}/bin/apr-1-config --with-apu=/usr/local/apache-#{node[:apache2][:version]}/bin/apu-1-config"
  end

  execute "Cleanup modsecurity-apache_#{node[:apache2][:mod_security_version]}" do
    command "/bin/rm -rf modsecurity-apache_#{node[:apache2][:mod_security_version]}"
    action :run
  end
end
