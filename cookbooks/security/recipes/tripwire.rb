unless File.exists?("/usr/local/sbin/tripwire")	
  extract "tripwire-#{node[:security][:tripwire_version]}-src" do
    action :enable
  end

  bash "Install tripwire" do
    code <<-EOH
      pushd "#{node[:common][:tmp_dir]}/tripwire-#{node[:security][:tripwire_version]}-src" >/dev/null
      ./configure
      make
      make install
      popd >/dev/null
    EOH
  end

  execute "Cleanup rkhunter" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/tripwire-#{node[:security][:tripwire_version]}-src"
  end
end
