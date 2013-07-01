include_recipe "cron"

cron "gmetric nginx status" do
  command "bash /root/ganglia/gmetric/nginx_status.sh"
  only_if "[ -f /root/ganglia/gmetric/nginx_status.sh ]"
end
