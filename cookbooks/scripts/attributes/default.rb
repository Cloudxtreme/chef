default[:scripts][:backup_host] = "10.0.0.1"

default[:scripts][:example_key][:users] = []

default[:scripts][:files] = []
default[:scripts][:functions][:root] = []
default[:scripts][:functions][:builder] = []
default[:scripts][:functions][:crontab] = []
default[:scripts][:functions][:users] = [ "builder", "crontab" ]

default[:scripts][:functions][:backup_dbs][:dir] = "/home/crontab/database-backups"
default[:scripts][:functions][:backup_dbs][:backup_dir] = "/data/database-backups"

default[:scripts][:functions][:backup_rrds][:rrd_dir] = "/var/lib/ganglia/rrds"
default[:scripts][:functions][:backup_rrds][:backup_dir] = "/home/crontab/rrds"
default[:scripts][:functions][:backup_rrds][:backup_file] = "ganglia_rrds"
default[:scripts][:functions][:backup_rrds][:remote_host] = "localhost"
default[:scripts][:functions][:backup_rrds][:remote_dir] = "/tmp"
default[:scripts][:functions][:backup_rrds][:do_transfer] = "false"

default[:scripts][:sftp][:dir] = "/home/crontab/database-backups"
default[:scripts][:sftp][:databases] = [ "mysql" ]
default[:scripts][:sftp][:hostname] = `hostname`.chomp
default[:scripts][:sftp_backups][:dir] = "/data"

default[:scripts][:root] = []

default[:scripts][:mysql][:cmd] = "/usr/local/mysql/bin/mysql"
default[:scripts][:mysql][:user] = "root"
default[:scripts][:mysql][:pass] = node[:hostname]
default[:scripts][:sync][:webservers] = [ "10.0.1.1", "10.0.1.2", "10.0.1.3" ]

default[:scripts][:functions][:php_errors][:log] = "/usr/local/php/logs/php-fpm.log"
default[:scripts][:functions][:fluent_logs][:log_dir] = "/var/log/fluent"

