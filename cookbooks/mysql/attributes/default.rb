case kernel[:machine]
when "x86_64"
    default[:mysql][:version] = "5.0.45-linux-x86_64-glibc23"
    default[:mysql][:percona][:version] = "5.5.16-rel22.0-189.Linux.x86_64"
when "i686"
    default[:mysql][:version] = "5.0.45-linux-i686-glibc23"
    default[:mysql][:percona][:version] = "5.5.16-rel22.0-189.Linux.i686"
end

case platform
when "centos","redhat","fedora"
  if kernel[:machine] == "x86_64"
    default[:mysql][:devel_ver] = "5.0.45-0.glibc23.x86_64"
    default[:mysql][:shared_ver] = "5.0.45-0.glibc23.x86_64"
  elsif kernel[:machine] == "i686"
    default[:mysql][:devel_ver] = "5.0.45-0.glibc23.i386"
    default[:mysql][:shared_ver] = "5.0.45-0.glibc23.i386"
  end
when "ubuntu","debian"
  if kernel[:machine] == "x86_64"
    default[:mysql][:client_version] = "5.0_5.0.45-1ubuntu3_amd64"
    default[:mysql][:lib_version] = "5.0.45-1ubuntu3.4_amd64"
  elsif kernel[:machine] == "i686"
    default[:mysql][:client_version] = "5.0_5.0.45-1ubuntu3.4_i386"
    default[:mysql][:lib_version] = "5.0.45-1ubuntu3.4_i386"
  end
end

default[:mysql][:install_dir] = "/usr/local"
default[:mysql][:server_id] = Time.now.to_i
default[:mysql][:template] = "default"
default[:mysql][:buffer_pool_size] = "512MB"
default[:mysql][:thread_cache_size] = `grep ^processor /proc/cpuinfo | wc -l`.to_i * 2
default[:mysql][:thread_concurrency] = `grep ^processor /proc/cpuinfo | wc -l`.to_i * 2
default[:mysql][:max_connections] = 1500
default[:mysql][:percona][:rpm_version] = "55"
default[:mysql][:auto_increment_increment] = 1
default[:mysql][:auto_increment_offset] = 1
default[:mysql][:log_slave_updates] = false
default[:mysql][:ssl_server] = false
default[:mysql][:binlog_ignore_dbs] = []
default[:mysql][:replicate_wild_do_tables] = []
default[:mysql][:server][:enable] = true
default[:mysql][:tmp_dir] = "/mnt/drive/tmp/"
