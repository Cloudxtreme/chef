default[:openmq][:dir]     = "/usr/local/openmq"
default[:openmq][:version] = "4.3"
default[:openmq][:hostname] = `hostname -s`.chomp
default[:openmq][:instance] = `hostname -s`.chomp
default[:openmq][:brokerlist] = []
