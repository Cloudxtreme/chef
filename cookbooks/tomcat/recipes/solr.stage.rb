group "solr" do
  gid 2019
end

user "solr" do
  uid 2019
  gid 2019
  home "/home/solr"
  shell "/bin/bash"
end

unless File.exists?("/usr/local/apache-tomcat-#{node[:tomcat][:version]}-solr")
  build_bin_full "apache-tomcat-#{node[:tomcat][:version]}" do
    action :enable
    install_dest "/usr/local/apache-tomcat-#{node[:tomcat][:version]}-solr"
    user "solr"
    group "solr"
    symlink "/usr/local/solr"
  end
end

template "/usr/local/apache-tomcat-#{node[:tomcat][:version]}-solr/bin/catalina.orig.sh" do
  source "catalina.orig.#{node[:tomcat][:version]}.erb"
  mode 0775
  owner "solr"
  group "solr"
  variables ({ 
    :java_opts => "-Xmx512m -Dsolr.solr.home=/usr/local/solr/solr", :app => "solr", :base => "/usr/local/solr"
  })
end

template "/usr/local/apache-tomcat-#{node[:tomcat][:version]}-solr/bin/catalina.sh" do
  source "catalina.stage.erb"
  mode 0755
  owner "solr"
  group "solr"
  variables ({ :app => "solr", :user => "solr", :base => "/usr/local/solr" })
end

template "/etc/init.d/solr" do
  source "tomcat.stage.erb"
  mode "755"
  variables ({ :app => "solr", :user => "solr" })
end

template "/etc/init.d/solr.server" do
  source "tomcat.server.erb"
  mode "755"
  variables ({ :app => "solr", :user => "solr", :solr_home => "/usr/local/solr/solr", :runlevels => "60 34" })
end

cookbook_file "/usr/local/apache-tomcat-#{node[:tomcat][:version]}-solr/webapps/solr.war" do
  source "solr.war"
  mode "644"
  owner "builder"
  group "builder"
  not_if "[ -f /usr/local/apache-tomcat-#{node[:tomcat][:version]}-solr/webapps/solr.war ]"
end

remote_directory "/usr/local/apache-tomcat-#{node[:tomcat][:version]}-solr/solr" do
  source "solr"
  owner "solr"
  group "solr"
  mode "0755"
  not_if "[ -d /usr/local/apache-tomcat-#{node[:tomcat][:version]}-solr/solr ]"
end
 
template "/usr/local/apache-tomcat-#{node[:tomcat][:version]}-solr/conf/server.xml" do
  source "solr-server.xml.erb"
  variables ({ :ipaddress => node[:tomcat][:ipaddress].length > 0 ? "address=\"#{node[:tomcat][:ipaddress]}\"" : '' })
  owner "solr"
  group "solr"
  mode "0600"
end
