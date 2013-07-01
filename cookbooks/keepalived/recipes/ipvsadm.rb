unless File.exists?("/sbin/ipvsadm")
  extract "ipvsadm-#{node[:keepalived][:ipvsadm_version]}" do
    action :enable
  end

  case node[:platform]
  when "redhat","centos","fedora"
    kernel = `uname -r`.chomp
    source_dir = "/usr/src/kernels"
  when "ubuntu","debian"
    kernel = "linux-headers"
    source_dir = "/usr/src"
  end

  bash "install ipvsadm" do
    code <<-EOH
      if [ ! -d "/usr/src/linux" ]; then
          SRC=$(find #{source_dir} -maxdepth 1 -name "#{kernel}*" | head -1)
          ln -s $SRC /usr/src/linux
      fi

      cd "#{node[:common][:tmp_dir]}/ipvsadm-#{node[:keepalived][:ipvsadm_version]}"
      make && make install
    EOH
  end

  add_line "net.ipv4.vs.expire_quiescent_template" do
    action :enable
    find 'net.ipv4.vs.expire_quiescent_template = 1'
    add 'net.ipv4.vs.expire_quiescent_template = 1'
    file "/etc/sysctl.conf"
  end

  add_line "net.ipv4.vs.expire_nodest_conn" do
    action :enable
    find 'net.ipv4.vs.expire_nodest_conn = 1'
    add 'net.ipv4.vs.expire_nodest_conn = 1'
    file "/etc/sysctl.conf"
  end

  execute "Cleanup ipvsadm" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/ipvsadm-#{node[:keepalived][:ipvsadm_version]}"
  end
end
