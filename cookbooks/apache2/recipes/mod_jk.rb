include_recipe "apache2::server"

unless File.exists?("/usr/local/apache-#{node[:apache2][:version]}/modules/mod_jk.so")
  extract "tomcat-connectors-#{node[:apache2][:mod_jk_version]}-src" do
    action :enable
  end

  build_src "tomcat-connectors-#{node[:apache2][:mod_jk_version]}-src/native" do
    action :enable
    options "--with-apxs=/usr/local/apache-#{node[:apache2][:version]}/bin/apxs"
  end

  execute "Cleanup tomcat-connectors" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/tomcat-connectors-#{node[:apache2][:mod_jk_version]}-src"
  end
end
