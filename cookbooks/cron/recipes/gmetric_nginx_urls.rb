include_recipe "cron"

cron "gmetric nginx urls" do
  command "bash /root/scripts/funcs.sh nginx_urls_gmetric"
  only_if "[ -f /root/scripts/functions/nginx_urls_gmetric ]"
end
