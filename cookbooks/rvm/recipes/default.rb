bash "install rvm #{node[:rvm][:version]}" do
  code <<-EOH
    if [ ! -d "#{node[:common][:tmp_dir]}" ]; then mkdir #{node[:common][:tmp_dir]}; fi
    pushd #{node[:common][:tmp_dir]} >/dev/null
    curl -s #{node[:rvm][:url]} -o rvm-installer
    chmod +x rvm-installer 
    ./rvm-installer --version #{node[:rvm][:version]}
    popd >/dev/null
  EOH
  not_if "[ -d /usr/local/rvm ]"
end
