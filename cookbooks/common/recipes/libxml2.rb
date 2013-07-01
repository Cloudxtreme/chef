unless File.exists?("/usr/local/libxml2-#{node[:common][:libxml2]}")
  extract "libxml2-#{node[:common][:libxml2]}" do
    action :enable
  end

  build_src "libxml2-#{node[:common][:libxml2]}" do
    action :enable
    options "--prefix=/usr/local/libxml2-#{node[:common][:libxml2]}"
  end

  execute "Cleanup libxml2" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/libxml2-#{node[:common][:libxml2]}"
  end
end

link "/usr/local/libxml2" do
  to "/usr/local/libxml2-#{node[:common][:libxml2]}"
  not_if "[ -L /usr/local/libxml2 ]"
end
