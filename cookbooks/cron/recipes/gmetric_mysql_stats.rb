include_recipe "cron"

cron "gmetric mysql stats" do
  command "/usr/bin/perl /root/ganglia/gmetric/mysql_stats.pl"
  only_if "[ -f /root/ganglia/gmetric/mysql_stats.pl ]"
end
