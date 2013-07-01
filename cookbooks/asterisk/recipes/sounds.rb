extract "sounds" do
  action :enable
end

bash "Asterisk sounds" do
  code <<-EOH
  mv /var/lib/asterisk/sounds /var/lib/asterisk/sounds~
  mv #{node[:common][:tmp_dir]}/sounds /var/lib/asterisk/
  EOH
  not_if do File.exists?("/var/lib/asterisk/sounds~") end
end
