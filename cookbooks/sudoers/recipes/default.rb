package "sudo"

replace_line "sudoers requiretty" do
  action :enable
  find 'Defaults    requiretty'
  add '#Defaults    requiretty'
  file "/etc/sudoers"
  not_if "egrep -q '^#Default.+requiretty' /etc/sudoers"
end

template "/etc/sudoers.include" do
  source "sudoers.include.erb"
  owner "root"
  group "root"
  mode "0440"
end

add_line "sudoers include" do
  action :enable
  find '#include /etc/sudoers.include'
  add '#include /etc/sudoers.include'
  file "/etc/sudoers"
  not_if "egrep -q '^#include.+/etc/sudoers.include' /etc/sudoers"
end
