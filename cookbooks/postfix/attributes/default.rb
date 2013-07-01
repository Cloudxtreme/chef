case kernel[:machine]
when "x86_64"
  default[:postfix][:dkim_version] = "2.8.3-1.x86_64"
  default[:postfix][:dk_version] = "1.0.2-0.x86_64"
when "i686"
  default[:postfix][:dkim_version] = "2.8.3-1.i386"
  default[:postfix][:dk_version] = "1.0.2-1.i386"
end

default[:postfix][:version] = "2.7.1"
default[:postfix][:total] = "60"

default[:postfix][:inet_interfaces] = "all"
default[:postfix][:dkim] = false
default[:postfix][:hostname] = `hostname`.chomp
default[:postfix][:mynetworks] = "127.0.0.0/8"
default[:postfix][:mydomains] = []
default[:postfix][:transport_maps] = []
default[:postfix][:trusted_hosts] = []
default[:postfix][:virtual_maps] = []
default[:postfix][:hold] = []

default[:postfix1][:port] = 26
default[:postfix1][:mynetworks] = "10.0.1.0/24, 127.0.0.0/8"
default[:postfix1][:mydestination] = "hash:/etc/postfix/mydomains"
default[:postfix1][:virtual] = "hash:/etc/postfix/virtual"
default[:postfix1][:transport] = "hash:/etc/postfix/transport"
default[:postfix1][:sender_access] = "hash:/etc/postfix/hold"
default[:postfix1][:interface] = "eth1"
