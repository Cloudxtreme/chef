case node[:platform]
when "centos","redhat","fedora"
  case node[:platform_version].split(".").first.to_i
  when 4
    pkg = "vixie-cron"
  when 5
    pkg = "vixie-cron"
  when 6
    pkg = "cronie"
  else
    pkg = "cronie"
  end

  package pkg
when "ubuntu","debian"
  package "cron"
end
