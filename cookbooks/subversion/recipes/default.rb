bash "install rpmforge" do
  code <<-EOH
  rpm -Uvh "#{node[:subversion][:rpmforge]}"
  [ -f /etc/yum.repos.d/rpmforge.repo ] && sed -i 's@enabled = 1@enabled = 0@g' /etc/yum.repos.d/rpmforge.repo
  EOH
  not_if "[ -f /etc/yum.repos.d/rpmforge.repo ]"
end

execute "install subversion" do
  command "yum --enablerepo=rpmforge -y install subversion"
  not_if "rpm -q subversion"
end
