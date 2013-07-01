if ! File.exists?("/etc/init.d/dahdi")

extract "dahdi-linux-complete-#{node[:asterisk][:dahdi_version]}" do
  action :enable
end

bash "Build dahdi" do
  code <<-EOH
  pushd "#{node[:common][:tmp_dir]}/dahdi-linux-complete-#{node[:asterisk][:dahdi_version]}"
  make all
  make install
  make config
  cp /etc/dahdi/modules /etc/dahdi/modules~
  echo -n > /etc/dahdi/modules
  /sbin/chkconfig --add dahdi
  /etc/init.d/dahdi start
  popd
  EOH
end

execute "cleanup" do
  command "/bin/rm -rf #{node[:common][:tmp_dir]}/dahdi-linux-complete-#{node[:asterisk][:dahdi_version]}"
  action :run
end

end
