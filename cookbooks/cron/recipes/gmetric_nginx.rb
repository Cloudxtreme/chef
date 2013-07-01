include_recipe "cron"

cron "gmetric nginx" do
  command "bash /root/scripts/funcs.sh nginx_gmetric"
  only_if "[ -f /root/scripts/functions/nginx_gmetric ]"
end
