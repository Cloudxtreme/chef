if ! File.exists?("/lib/libwgetaddrinfo.so")
  extract "libwgetaddrinfo" do
    action :enable
  end

  bash "Build libwgetaddrinfo" do
    code <<-EOH
      pushd "#{node[:common][:tmp_dir]}/libwgetaddrinfo"
      make all
      mv libwgetaddrinfo* /lib/
      popd
    EOH
  end

  bash "Setup libwgetaddrinfo preload" do
    code <<-EOH
      if [ `grep "libwgetaddrinfo.so" /etc/ld.so.preload | wc -l` -eq 0 ]; then
        echo "/lib/libwgetaddrinfo.so" >> /etc/ld.so.preload
	export LD_PRELOAD=/lib/libwgetaddrinfo.so
        /sbin/ldconfig
      fi
    EOH
    only_if do File.exists?("/lib/libwgetaddrinfo.so") end
  end

  execute "Cleanup libwgetaddrinfo" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/libwgetaddrinfo"
    action :run
  end
end

