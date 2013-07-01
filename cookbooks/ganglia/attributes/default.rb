case kernel[:machine]
when "x86_64"
  default[:ganglia][:arch] = "x86_64"
when "i686"
  default[:ganglia][:arch] = "i386"
end

default[:ganglia][:libganglia][:version] = "3.2.0-1"
default[:ganglia][:libconfuse][:version] = "2.6-2.el5.rf"
default[:ganglia][:gmond][:version] = "3.2.0-1"
default[:ganglia][:gmetad][:version] = "3.2.0-1"
default[:ganglia][:gmetad][:clusters] = {} 
default[:ganglia][:gmetad][:trusted_hosts] = [ "127.0.0.1" ]
default[:ganglia][:gmetad][:xml_port] = "8651"
default[:ganglia][:gmetad][:gridname] = "unspecified"

default[:ganglia][:mysqladmin] = "/usr/local/mysql/bin/mysqladmin"
default[:ganglia][:mysql_user] = "ganglia"
default[:ganglia][:mysql_pass] = "gangl1a"

default[:ganglia][:host] = "ganglia.localdomain"
default[:ganglia][:port] = "8649"
default[:ganglia][:name] = "default"
default[:ganglia][:collector] = false
default[:ganglia][:tcp_accept_port] = "8649"

default[:ganglia][:send_metadata_interval] = "60"
default[:ganglia][:gmetric][:scripts] = %w{
  apache_error.pl
  nginx_error.pl
  nginx_status.sh
  tcp_connections.sh
  tcp_established_time_wait.sh
  mysql_stats.pl
  tcp_connections.pl
  tcp_established.sh
}
