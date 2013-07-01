case platform 
when "ubuntu","debian"
  default[:ntp][:service] = "ntp"
when "redhat","centos","fedora","scientific"
  default[:ntp][:service] = "ntpd"
end

default[:ntp][:is_server] = false
default[:ntp][:servers]   = ["0.uk.pool.ntp.org", "1.uk.pool.ntp.org", "2.uk.pool.ntp.org", "3.uk.pool.ntp.org"]

