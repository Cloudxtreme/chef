include_recipe "ant"
include_recipe "java"
hostname = `hostname -s`.chomp

case node[:platform]
when "centos", "redhat", "fedora"
  yum_package "glibc" do
    arch "i686"
  end
end

unless File.exists?("/usr/local/anthill3/#{node[:anthill][:hostname]}")
  execute "get file" do
    command "wget -O #{node[:common][:tmp_dir]}/#{node[:anthill][:hostname]}.tar.gz #{node[:common][:host]}/#{node[:anthill][:hostname]}.tar.gz --no-check-certificate"
  end

  bash "unattended install of anthill agent" do 
    code <<-EOH
    if [ -f #{node[:common][:tmp_dir]}/#{node[:anthill][:hostname]}.tar.gz ]; then
      cd /
      tar -zxvf #{node[:common][:tmp_dir]}/#{node[:anthill][:hostname]}.tar.gz
      echo "mv /usr/local/anthill3/#{node[:anthill][:hostname]}/bin/ah3agent /usr/local/anthill3/#{node[:anthill][:hostname]}/bin/ah3agent.orig"
      chown -R builder.builder /usr/local/anthill3/
    else
      echo "#{hostname}.tar.gz does not exist" && return 1
    fi
    EOH
    not_if "[ -d /usr/local/anthill3/#{node[:anthill][:hostname]} ]"
  end

  execute "cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/#{node[:anthill][:hostname]}.tar.gz"
  end
end

template "/etc/init.d/anthill.agent" do
  source "anthill.agent.erb"
  mode "755"
end

template "/usr/local/anthill3/#{node[:anthill][:hostname]}/bin/ah3agent" do
  source "ah3agent.erb"
  owner "builder"
  group "builder"
  mode "755"
end

template "/usr/local/anthill3/#{node[:anthill][:hostname]}/bin/ah3agent.orig" do
  source "ah3agent.orig.erb"
  owner "builder"
  group "builder"
  mode "755"
end

service "anthill.agent" do
  action [:enable, :start]
end

