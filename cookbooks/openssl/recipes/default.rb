unless File.exist?("/usr/local/openssl-#{node[:openssl][:version]}")
  extract "openssl-#{node[:openssl][:version]}" do
    action :enable
  end

  build_src "openssl-#{node[:openssl][:version]}" do
    action :enable
    options "--prefix=/usr/local/openssl-#{node[:openssl][:version]}"
  end

 link "/usr/local/openssl" do
   to "/usr/local/openssl-#{node[:openssl][:version]}"
   not_if "[ -L /usr/local/openssl ]"
 end

  execute "cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/openssl-#{node[:openssl][:version]}"
  end
end

