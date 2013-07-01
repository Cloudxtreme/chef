include_recipe "cron"

cron "fluent_logs" do
  hour "6"
  minute "0"
  command "bash /root/scripts/funcs.sh fluent_logs"
  only_if "[ -f /root/scripts/functions/fluent_logs ]"
end
