default[:monit][:version] = "5.3.1"
default[:monit][:hostname] = `hostname`.chomp
default[:monit][:alert_address] = "support@example.com"

default[:monit][:mmonit][:hosts] = [ "127.0.0.1:8080" ]
default[:monit][:network] = "127.0.0.1"
default[:monit][:drives] = {}
default[:monit][:services][:app] = []

default[:monit][:services][:ping] = {}
default[:monit][:services2][:app] = {}
default[:monit][:services][:urls] = {}

default[:monit][:haproxy][:pidfile] = "/usr/local/haproxy/etc/haproxy.pid"
default[:monit][:haproxy][:port] = "9090"
default[:monit][:nginx][:port] = 81
default[:monit][:nginx][:host] = "127.0.0.1"
default[:monit][:nginx][:checks] = ""
default[:monit][:lbs] = {}

default[:monit][:php][:pid_file] = "/usr/local/php/logs/php-fpm.pid"
default[:monit][:actions] = [ :enable ]

default[:monit][:gmond][:port] = "8649"
default[:monit][:gmond][:mem] = "500.0"
default[:monit][:gmond][:host] = "127.0.0.1"
