default[:nginx][:version] = "1.0.15"
default[:nginx][:processes] = 8
default[:nginx][:rlimit] = 8192
default[:nginx][:connections] = 1024
default[:nginx][:keepalive_timeout] = 65
default[:nginx][:access_log] = "logs/access.log  main"
default[:nginx][:vhost][:templates] = []
default[:nginx][:key_pass] = `cat /dev/urandom | tr -dc 'a-zA-Z0-9$\!\*\\' | head -c 20`.chomp
default[:nginx][:vhost][:ssl_domain] = "localhost.localdomain"

default[:nginx][:actions] = [ :enable ]
default[:nginx][:include_files] = []
default[:nginx][:install_dir] = "/usr/local"
default[:nginx][:listeners] = [ "80" ]
default[:nginx][:install_modules] = [ "http_stub_status_module", "http_ssl_module" ]
