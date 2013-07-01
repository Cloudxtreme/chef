include_recipe "nginx"

install_dir = node[:nginx][:install_dir]

%w{ nginx ssl }.each do |file|
  template "#{install_dir}/nginx-#{node[:nginx][:version]}/conf/#{file}.conf" do
    source "#{file}.conf.erb"
    owner "root"
    group "root"
    mode 0644
  end
end

directory "#{install_dir}/nginx-#{node[:nginx][:version]}/conf/vhosts" do
  recursive true
  owner "root"
  group "root"
  mode 0755
end

node[:nginx][:vhost][:templates].each do |template|
  template "#{install_dir}/nginx-#{node[:nginx][:version]}/conf/vhosts/#{template}.conf" do
    notifies :reload, "service[nginx]"
    source "vhosts/#{template}.conf.erb"
    owner "root"
    group "root"
    mode 0644
  end
end

node[:nginx][:include_files].each do |template|
  template "#{install_dir}/nginx-#{node[:nginx][:version]}/conf/#{template}.conf" do
    source "#{template}.conf.erb"
    owner "root"
    group "root"
    mode 0644
  end
end

bash "create ssl certificate" do
  code <<-EOH
    echo "#{node[:nginx][:key_pass]}" > /root/ssl_pass.txt

    openssl genrsa -des3 -passout file:/root/ssl_pass.txt \
        -out #{install_dir}/nginx-#{node[:nginx][:version]}/conf/server.key.orig 2048

    openssl rsa -in #{install_dir}/nginx-#{node[:nginx][:version]}/conf/server.key.orig \
        -passin file:/root/ssl_pass.txt -out #{install_dir}/nginx-#{node[:nginx][:version]}/conf/server.key

    openssl req -new -subj '/CN=#{node[:nginx][:vhost][:ssl_domain]}/O=Example.com Ltd/C=GB/ST=London/L=London' \
        -key #{install_dir}/nginx-#{node[:nginx][:version]}/conf/server.key -out /root/server.csr

    openssl x509 -req -days 3650 -in /root/server.csr -signkey #{install_dir}/nginx-#{node[:nginx][:version]}/conf/server.key \
        -out #{install_dir}/nginx-#{node[:nginx][:version]}/conf/server.crt

    rm -f /root/server.csr /root/ssl_pass.txt /root/ssl_req.txt
  EOH
  not_if "[ -f #{install_dir}/nginx-#{node[:nginx][:version]}/conf/server.crt ]"
end

service "nginx" do
  supports :restart => true, :reload => true
  action node[:nginx][:actions]
end
