group "tomcat" do
  gid 2004
end

user "tomcat" do
  uid 2004
  gid 2004
  home "/home/tomcat"
  shell "/bin/bash"
end

unless File.exists?("/usr/local/apache-tomcat-#{node[:tomcat][:version]}")
  build_bin_full "apache-tomcat-#{node[:tomcat][:version]}" do
    action :enable
    install_dest "/usr/local/apache-tomcat-#{node[:tomcat][:version]}"
    user "tomcat"
    group "tomcat"
    symlink "/usr/local/tomcat"
  end
end

template "/usr/local/apache-tomcat-#{node[:tomcat][:version]}/bin/catalina.orig.sh" do
  source "catalina.orig.#{node[:tomcat][:version]}.erb"
  mode 0775
  owner "tomcat"
  group "tomcat"
  variables ({ :java_opts => node[:tomcat][:java_opts], :app => "tomcat", :base => "/usr/local/tomcat" })
end

template "/usr/local/apache-tomcat-#{node[:tomcat][:version]}/bin/catalina.sh" do
  source "catalina.erb"
  mode 0755
  owner "tomcat"
  group "tomcat"
  variables ({ :app => "tomcat", :user => "tomcat", :base => "/usr/local/tomcat" })
end

template "/etc/init.d/tomcat" do
  source "tomcat.erb"
  mode "4755"
  variables ({ :app => "tomcat", :user => "tomcat" })
end

template "/etc/init.d/tomcat.server" do
  source "tomcat.server.erb"
  mode "755"
  variables ({ :app => "tomcat",  :user => "tomcat", :runlevels => "95 33" })
end

directory "/usr/local/apache-tomcat-#{node[:tomcat][:version]}/webapps" do
  mode "0775"
  owner "builder"
  group "builder"
end

template "/etc/profile.d/tomcat.sh" do
  source "tomcat.sh.erb"
  backup 0
  mode 0755
  owner "root"
  group "root"
end
