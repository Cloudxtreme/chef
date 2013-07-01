default[:apache2][:version] = "2.2.19"
default[:apache2][:dir]     = "/usr/local/apache-2.2.19"
default[:apache2][:log_dir] = "/usr/local/apache2/logs"
default[:apache2][:user]    = "nobody"
default[:apache2][:binary]  = "/usr/local/apache2/bin/httpd"
default[:apache2][:icondir] = "/usr/local/apache2/icons"
default[:apache2][:mpm] = "worker"
default[:apache2][:mod_fastcgi_version] = "2.4.6.1"
default[:apache2][:mod_jk_version] = "1.2.21"
default[:apache2][:mod_security_version] = "2.5.12"

# General settings
default[:apache2][:listen_ports] = [ "80", "443" ]     unless apache2.has_key?(:listen_ports)
default[:apache2][:contact] = "ops@example.com" unless apache2.has_key?(:contact)
default[:apache2][:timeout] = 300               unless apache2.has_key?(:timeout)
default[:apache2][:keepalive] = "On"            unless apache2.has_key?(:keepalive)
default[:apache2][:keepaliverequests] = 100     unless apache2.has_key?(:keepaliverequests)
default[:apache2][:keepalivetimeout] = 5        unless apache2.has_key?(:keepalivetimeout)

# Prefork Attributes
default[:apache2][:prefork] = Mash.new unless apache2.has_key?(:prefork)
default[:apache2][:prefork][:startservers] = 16      unless default[:apache2][:prefork].has_key?(:prefork_startservers)
default[:apache2][:prefork][:minspareservers] = 16   unless default[:apache2][:prefork].has_key?(:prefork_minspareservers)
default[:apache2][:prefork][:maxspareservers] = 32   unless default[:apache2][:prefork].has_key?(:prefork_maxspareservers)
default[:apache2][:prefork][:maxclients] = 400       unless default[:apache2][:prefork].has_key?(:prefork_maxclients)
default[:apache2][:prefork][:maxrequestsperchild] = 10000 unless default[:apache2][:prefork].has_key?(:prefork_maxrequestsperchild)

# Worker Attributes
default[:apache2][:worker] = Mash.new unless apache2.has_key?(:worker)
default[:apache2][:worker][:startservers] = 4        unless default[:apache2][:worker].has_key?(:startservers)
default[:apache2][:worker][:maxclients] = 1024       unless default[:apache2][:worker].has_key?(:maxclients)
default[:apache2][:worker][:minsparethreads] = 64    unless default[:apache2][:worker].has_key?(:minsparethreads)
default[:apache2][:worker][:maxsparethreads] = 192   unless default[:apache2][:worker].has_key?(:maxsparethreads)
default[:apache2][:worker][:threadsperchild] = 64    unless default[:apache2][:worker].has_key?(:threadsperchild)
default[:apache2][:worker][:maxrequestsperchild] = 0 unless default[:apache2][:worker].has_key?(:maxrequestsperchild)

