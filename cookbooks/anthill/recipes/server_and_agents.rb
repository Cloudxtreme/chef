include_recipe "anthill::server"

  extract "anthill#{node[:anthill][:version]}" do
    action :enable
  end

 bash "unattended installation of anthill agent" do
    code <<-EOH
      export JAVA_HOME=/usr/local/java
      export PATH=/usr/local/mysql/bin:/user/local/ant/bin:/usr/local/java/bin:$PATH

      pushd #{node[:common][:tmp_dir]}/anthill3-install >/dev/null

      i=1
      while [ $i -le "#{node[:anthill][:agent_count]}" ]
      do
        /usr/local/ant/bin/ant \
          "-Dinstall-agent=true" \
          "-Dinstall-server=false" \
          "-Dinstall.java.home=#{node[:anthill][:java_home]}" \
          "-Dinstall.agent.connect_via_relay=#{node[:anthill][:agent_connect_via_relay]}" \
          "-Dinstall.agent.jms.remote.host=#{node[:anthill][:agent_jms_remote_host]}" \
          "-Dinstall.agent.jms.remote.port=#{node[:anthill][:agent_jms_remote_port]}" \
          "-Dinstall.agent.relay.http.port=#{node[:anthill][:agent_relay_http_port]}" \
          "-Dinstall.agent.remote.port.ssl=#{node[:anthill][:agent_remote_port_ssl]}" \
          "-Dinstall.agent.remote.port.mutual_auth=#{node[:anthill][:agent_remote_port_mutual_auth]}" \
          "-Dinstall.agent.name=#{node[:anthill][:agent_name]}-$i" \
          "-Dinstall.agent.dir=#{node[:common][:tmp_dir]}/#{node[:anthill][:agent_name]}$i" \
          -f install.with.groovy.xml install-non-interactive

         tar -zcvf #{node[:anthill][:agent_name]}$i.tar.gz ../#{node[:common][:tmp_dir]}/#{node[:anthill][:agent_name]}$i
         
         i=`expr $i + 1`
       done    
    EOH

    execute "cleanup" do
      command "/bin/rm -rf #{node[:common][:tmp_dir]}/"
    end
  end
    
  


