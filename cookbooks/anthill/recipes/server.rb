require_recipe "ant"
require_recipe "mysql"
require_recipe "java"

unless File.exists?("/usr/local/anthill3/server")
  extract "anthill#{node[:anthill][:version]}" do
    action :enable
  end

  bash "unattended installation of anthill server" do
    code <<-EOH
      export JAVA_HOME=/usr/local/java
      export PATH=/usr/local/mysql/bin:/user/local/ant/bin:/usr/local/java/bin:$PATH

      mysqladmin -uroot create anthill3
      echo "grant all privileges on anthill3.* to '#{node[:anthill][:db_user]}'@'localhost' identified by '#{node[:anthill][:db_passwd]}'" | mysql -uroot >/dev/null
      pushd #{node[:common][:tmp_dir]}/anthill3-install >/dev/null

      wget "#{node[:common][:host]}/mysql-connector-java-#{node[:anthill][:mysql_connector_version]}-bin.jar" --no-check-certificate >/dev/null
      cp mysql-connector-java-#{node[:anthill][:mysql_connector_version]}-bin.jar lib/ >/dev/null


       echo $JAVA_HOME
      /usr/local/ant/bin/ant \
      "-Dinstall-agent=false" \
      "-Dinstall-server=true" \
      "-Dinstall.java.home=#{node[:anthill][:java_home]}" \
      "-Dinstall.server.dir=#{node[:anthill][:install_dir]}" \
      "-Dinstall.server.port=#{node[:anthill][:server_port]}" \
      "-Dinstall.server.web.ip=#{node[:anthill][:web_ip]}" \
      "-Dinstall.server.web.always.secure=#{node[:anthill][:web_secure]}" \
      "-Dinstall.server.web.https.port=#{node[:anthill][:web_https_port]}" \
      "-Dinstall.server.jms.port=#{node[:anthill][:jms_port]}" \
      "-Dinstall.db.type=#{node[:anthill][:db_type]}" \
      "-Dinstall.db.driver=#{node[:anthill][:db_driver]}" \
      "-Dinstall.db.url=#{node[:anthill][:db_url]}" \
      "-Dinstall.db.user=#{node[:anthill][:db_user]}" \
      "-Dinstall.db.password=#{node[:anthill][:db_passwd]}" \
      "-Dinstall.server.jms.mutual.auth=#{node[:anthill][:jms_mutual_auth]}" \
      "-Dinstall.keystore.password=#{node[:anthill][:keystore_pwd]}" \
      -f install.with.groovy.xml install-non-interactive >/dev/null

      mv "mysql-connector-java-#{node[:anthill][:mysql_connector_version]}-bin.jar" /usr/local/anthill3/server/lib/ >/dev/null
    EOH
  end

  execute "change ownership to builder" do
    command "/bin/chown -R builder.builder #{node[:anthill][:install_dir]}"
  end

  execute "cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/"
  end
end

