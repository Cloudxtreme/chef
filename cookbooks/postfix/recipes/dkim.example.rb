include_recipe "postfix::dk"
include_recipe "postfix::dkim"

template "/etc/mail/dkim/keylist" do
  source "keylist.erb"
  mode "0640"
  group	"dkim-milt"
  owner "dkim-milt"
end

template "/etc/mail/dkim/trusted-hosts" do
  source "trusted-hosts.erb"
  mode "0640"
  group	"dkim-milt"
  owner "dkim-milt"
end

template "/etc/dkim-filter.conf" do
  source "dkim-filter.conf.erb"
  mode "0640"
  group "dkim-milt"
  owner "dkim-milt"
end

directory "/etc/mail/dkim/keys/mail.example.com" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

template "/etc/mail/dkim/keys/mail.example.com/default" do
  source "default.erb"
  mode "0600"
  group "dkim-milt"
  owner "dkim-milt"
end

template "/etc/mail/domainkeys/dk_mail.example.com.pem" do
  source "default.erb"
  mode "0600"
  group "dk-milt"
  owner "dk-milt"
end

template "/etc/mail/domainkeys/trusted-hosts" do
  source "trusted-hosts.erb"
  mode "0640"
  group "dk-milt"
  owner "dk-milt"
end

template "/etc/sysconfig/dk-milter" do
  source "dk-milter.erb"
  mode "0644"
  group "root"
  owner "root"
end
