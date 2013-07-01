include_recipe "tomcat::standard"

template "/usr/local/apache-tomcat-#{node[:tomcat][:version]}/conf/server.xml" do
  source "server.xml.erb"
  owner "tomcat"
  group "tomcat"
  mode 0644
end

template "/usr/local/apache-tomcat-#{node[:tomcat][:version]}/conf/context.xml" do
  source "context.xml.erb"
  owner "tomcat"
  group "tomcat"
  mode 0644
end

