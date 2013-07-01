# default tomcat settings

default[:tomcat][:hostname] = `hostname -s`.chomp
default[:tomcat][:version] = "6.0.32"
default[:tomcat][:mysql_connector_version] = "5.0.4"
default[:tomcat][:java_opts] = ""
default[:tomcat][:ipaddress] = ""

# server.xml

default[:tomcat][:shutdown_port] = 8005
default[:tomcat][:connector_port] = 8080
default[:tomcat][:redirect_port] = 8443
default[:tomcat][:ajp_connector_port] = 8009
default[:tomcat][:ajp_redirect_port] = 8443
default[:tomcat][:unpack_wars] = "false"
default[:tomcat][:auto_deploy] = "false"
default[:tomcat][:contexts] = []

# context.xml

default[:tomcat][:disable_url_rewriting] = true
default[:tomcat][:localhost_access_log] = true
