include_recipe "cron"

cron "gmetric tcp connections" do
  command "/usr/bin/perl /root/ganglia/gmetric/tcp_connections.pl"
  only_if "[ -f /root/ganglia/gmetric/tcp_connections.pl ]"
end
