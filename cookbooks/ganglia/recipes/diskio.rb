unless File.exists?("/usr/bin/g_linux_disk") 
  extract "gmetric" do
    action :run
  end

  bash "build diskio" do
    code <<-EOH
    pushd "#{node[:common][:tmp_dir]}/gmetric" >/dev/null
    gcc  g_linux_disk.c -o /usr/bin/g_linux_disk
    popd >/dev/null
    EOH
   end
 
  execute "cleanup gmetric" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/gmetric"
  end
end

template "/etc/init.d/diskio" do
  source "diskio.erb"
  mode 0755
  owner "root"
  group "root"
end

service "diskio" do
  pattern "g_linux_disk"
  action [ :enable, :start ]
end
