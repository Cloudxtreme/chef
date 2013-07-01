
default[:common][:host] = "http://chef.localdomain/archive"
default[:common][:archive] = "/usr/local/archive"
default[:common][:tmp_dir] = "/usr/local/chef-tmp"
default[:common][:resource_list] = "/usr/local/archive/resource.list"
default[:common][:libxml2] = "2.7.6"
default[:common][:libxslt] = "1.1.26"
default[:common][:erlang] = "R13B04"

default[:common][:users][:manage_home] = false
default[:common][:users][:create] = true
default[:common][:users][:use] = "default"
default[:common][:users][:default] = { 
  "builder" => 2001,
  "crontab" => 2002,
  "mysql" => 2003,
  "tomcat" => 2004,
  "openmq" => 2005,
  "jmx-management" => 2006,
  "solr" => 2007,
  "ums" => 2008
}

case platform
when "centos","redhat","fedora"
  if kernel[:machine] == "x86_64"
    default[:common][:p7zip] = "p7zip-9.20.1-2.el5.x86_64"
    default[:common][:p7zip_plugin] = "p7zip-plugins-9.20.1-2.el5.x86_64"
  elsif kernel[:machine] == "i686"
    default[:common][:p7zip] = "p7zip-9.13-1.el5.rf.i386"
    default[:common][:p7zip_plugin] = "p7zip-plugins-9.13-1.el5.rf.i386"
  end
end

default[:common][:vips] = []
default[:common][:hosts] = {}
default[:common][:set_localhost_name] = true

default[:common][:locale][:lang] = "en_US.UTF-8"
default[:common][:locale][:sysfont] = "latarcyrheb-sun16"
