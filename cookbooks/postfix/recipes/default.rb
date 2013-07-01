case node[:platform]
when "ubuntu","debian"
  %w{ libsasl2-2 libsasl2-modules }.each do |pkg|
    package pkg do
      action :install
    end
  end
when "redhat","centos","fedora"
  package "cyrus-sasl" do
    action :install
  end
end

package "postfix" do
  action :install
end

%w{ main.cf transport mydomains hold virtual }.each do |config|
  template "/etc/postfix/#{config}" do
    source "#{config}.erb"
    mode "0644"
  end
end

%w{ virtual mydomains hold transport }.each do |file|
  execute "hash #{file}" do
    command "/usr/sbin/postmap /etc/postfix/#{file}"
    only_if "[ ! -f /etc/postfix/#{file}.db ]||[ /etc/postfix/#{file} -nt /etc/postfix/#{file}.db ]"
  end
end

if node[:postfix][:sender_dependent_relayhost_map]
  template "/etc/postfix/sender_dependent_relayhost" do
    source "sender_dependent_relayhost.erb"
    mode "0644"
  end

  execute "hash sender_dependent_relayhost" do
    command "/usr/sbin/postmap /etc/postfix/sender_dependent_relayhost"
    only_if "[ ! -f /etc/postfix/sender_dependent_relayhost.db ]||[ /etc/postfix/sender_dependent_relayhost -nt /etc/postfix/sender_dependent_relayhost.db ]"
  end
end

service "postfix" do
  action :enable
end
