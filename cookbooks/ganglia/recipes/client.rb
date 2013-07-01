case node[:platform]
when "ubuntu", "debian"
  package "ganglia-monitor"
  gmond_service = "ganglia-monitor"

  node[:ganglia][:module_path] = "/usr/lib/ganglia/"
when "centos","redhat","fedora"
  gmond_service = "gmond"

  case node[:platform_version].split(".").first.to_i
  when 6
    expat = "compat-expat1"
  else
    expat = "expat"
  end

  package expat

  [ 
    "libconfuse-#{node[:ganglia][:libconfuse][:version]}",
    "libganglia-#{node[:ganglia][:libganglia][:version]}",
    "ganglia-gmond-#{node[:ganglia][:gmond][:version]}" 
  ].each do |pkg|
    install_rpm "#{pkg}.#{node[:ganglia][:arch]}" do
      action :enable
      k pkg
      v "#{pkg}.#{node[:ganglia][:arch]}"
    end                  
  end

  node[:ganglia][:module_path] = ""
end

template "/etc/ganglia/gmond.conf" do
  source "gmond.conf.erb"
  mode "0755"
  notifies :restart, "service[#{gmond_service}]"
end

service "#{gmond_service}" do
  pattern "gmond"
  supports :restart => true
  action [ :enable, :start ]
end
