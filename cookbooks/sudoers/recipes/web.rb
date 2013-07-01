replace_line "sudoers requiretty" do
  action :enable
  find 'Defaults    requiretty'
  add '#Defaults    requiretty'
  file "/etc/sudoers"
  not_if "egrep -q '^#Default.+requiretty' /etc/sudoers"
end

add_line "sudoers include" do
  action :enable
  find '#include /etc/sudoers.web'
  add '#include /etc/sudoers.web'
  file "/etc/sudoers"
  not_if "egrep -q '^#include.+/etc/sudoers.web' /etc/sudoers"
end

template "/etc/sudoers.web" do
  source "sudoers.web.erb"
  mode "0440"
end
