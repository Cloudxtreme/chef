replace_line "sudoers requiretty" do
  action :enable
  find 'Defaults    requiretty'
  add '#Defaults    requiretty'
  file "/etc/sudoers"
  not_if do File.exists?("/etc/sudoers.stage") end
end

add_line "sudoers include" do
  action :enable
  find '#include /etc/sudoers.stage'
  add '#include /etc/sudoers.stage'
  file "/etc/sudoers"
  not_if do File.exists?("/etc/sudoers.stage") end
end

template "/etc/sudoers.stage" do
  source "sudoers.stage.erb"
  mode "0440"
end
