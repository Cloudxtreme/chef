case node[:platform]
when "centos","redhat","fedora"
  include_recipe "keepalived::ipvsadm"

  unless File.exists?("/usr/local/sbin/keepalived")
    extract "keepalived-#{node[:keepalived][:version]}" do
      action :enable
    end

    build_src "keepalived-#{node[:keepalived][:version]}" do
      action :enable
      not_if "[ -f /usr/local/sbin/keepalived ]"
    end

    execute "Cleanup keepalived" do
      command "/bin/rm -rf #{node[:common][:tmp_dir]}/keepalived-#{node[:keepalived][:version]}"
    end
  end

  template "/etc/init.d/keepalived" do
    source "keepalived.init.erb"
    mode "0755"
    backup 0
  end
when "ubuntu","debian"
  package "keepalived"
end

