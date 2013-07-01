group "ums" do
  gid 2024
end

user "ums" do
  uid 2024
  gid 2024
  home "/home/ums"
  shell "/bin/bash"
end

unless File.exists?("/usr/local/apache-tomcat-#{node[:tomcat][:version]}-ums")
  build_bin_full "apache-tomcat-#{node[:tomcat][:version]}" do
    action :enable
    install_dest "/usr/local/apache-tomcat-#{node[:tomcat][:version]}-ums"
    user "ums"
    group "ums"
    symlink "/usr/local/ums"
  end
end

template "/usr/local/apache-tomcat-#{node[:tomcat][:version]}-ums/bin/catalina.orig.sh" do
  source "catalina.orig.#{node[:tomcat][:version]}.erb"
  mode 0775
  owner "ums"
  group "ums"
  variables ({ :java_opts => "-Xmx512m", :app => "ums", :base => "/usr/local/ums" })
end

template "/usr/local/apache-tomcat-#{node[:tomcat][:version]}-ums/bin/catalina.sh" do
  source "catalina.erb"
  mode 0755
  owner "ums"
  group "ums"
  variables ({ :app => "ums", :user => "ums", :base => "/usr/local/ums" })
end

template "/etc/init.d/ums" do
  source "tomcat.erb"
  mode "4755"
  variables ({ :app => "ums", :user => "ums" })
end

template "/etc/init.d/ums.server" do
  source "tomcat.server.erb"
  mode "755"
  variables ({ :app => "ums", :user => "ums", :ums_home => "/usr/local/ums", :runlevels => "60 34" })
end

cookbook_file "/usr/local/apache-tomcat-#{node[:tomcat][:version]}-ums/webapps/imqums.war" do
  source "imqums.war"
  mode "644"
  owner "builder"
  group "builder"
  not_if "[ -f /usr/local/apache-tomcat-#{node[:tomcat][:version]}-ums/webapps/imqums.war ]"
end

template "/usr/local/apache-tomcat-#{node[:tomcat][:version]}-ums/conf/server.xml" do
  source "ums-server.xml.erb"
  mode "0600"
  owner "ums"
  group "ums"
  variables ({ :ipaddress => node[:tomcat][:ipaddress].length > 0 ? "address=\"#{node[:tomcat][:ipaddress]}\"" : '' })
end
