rcfile = File.ftype("/etc/rc.local") == "link" ? "/etc/rc.d/rc.local" : "/etc/rc.local"

template "#{rcfile}" do
  source "rc.local.web.erb"
  owner "root"
  group "root"
  mode 0755
end
