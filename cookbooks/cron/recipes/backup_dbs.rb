include_recipe "cron"

cron "backup_dbs" do
  user "crontab"
  hour "1"
  minute "0"
  command "bash /home/crontab/scripts/funcs.sh backup_dbs >/home/crontab/logs/backup_dbs.log"
  only_if "[ -f /home/crontab/scripts/functions/backup_dbs ]"
end
