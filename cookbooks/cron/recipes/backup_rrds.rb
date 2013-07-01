include_recipe "cron"

cron "backup_rrds" do
  user "crontab"
  hour "0"
  minute "0"
  command "bash /home/crontab/scripts/funcs.sh backup_rrds >/home/crontab/logs/backup_rrds.log"
  only_if "[ -f /home/crontab/scripts/functions/backup_rrds ]"
end
