# paths
file_cache_path "/usr/local/chef/chef-solo"
file_backup_path "#{file_cache_path}/backups"
cookbook_path "#{file_cache_path}/cookbooks"

# logging
log_level :info
log_location "/usr/local/chef/logs/client.log"
verbose_logging nil

# ssl verify none
ssl_verify_mode :verify_none

# base urls
base_url "http://chef.localdomain"

# cookbook url
recipe_url "#{base_url}/cookbooks.tar.gz"

# location
location = ENV['CHEF_LOCATION'] ? ENV['CHEF_LOCATION'] : "default"

# role
role = ENV['CHEF_ROLE'] ? ENV['CHEF_ROLE'] : "default"

# json attributes url

json_attribs "#{base_url}/install/client/#{location}/#{role}.chef.json"
