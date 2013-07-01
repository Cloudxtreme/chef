unless File.exists?("/usr/local/jdk#{node[:java][:version]}")
  build_bin_full "jdk#{node[:java][:version]}" do
    action :enable
    install_dest "/usr/local/jdk#{node[:java][:version]}"
    user "root"
    group "root"
    symlink "/usr/local/java"
  end
end

if ! File.exists?("/usr/local/jdk#{node[:java][:version]}/jre/lib/security/local_policy.jar") && ! File.exists?("/usr/local/jdk#{node[:java][:version]}/jre/lib/security/US_export_policy.jar")
  extract "jce_policy-#{node[:java][:jce_version]}" do
    action :enable
  end

  bash "install jce_policy-#{node[:java][:jce_version]}" do
    code <<-EOH
    cp -arp "#{node[:common][:tmp_dir]}"/jce/* "/usr/local/jdk#{node[:java][:version]}/jre/lib/security/"
    EOH
  end

  execute "cleanup " do
    command "/bin/rm -rf "#{node[:common][:tmp_dir]}/jce"
  end
end

template "/etc/profile.d/java.sh" do
  source "java.sh.erb"
  backup 0
  mode 0755
  owner "root"
  group "root"
end
