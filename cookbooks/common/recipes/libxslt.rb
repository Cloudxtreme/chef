if ! File.exists?("/usr/local/libxslt-#{node[:common][:libxslt]}")
  extract "libxslt-#{node[:common][:libxslt]}" do
    action :enable
  end

  build_src "libxslt-#{node[:common][:libxslt]}" do
    action :enable
    options "--prefix=/usr/local/libxslt-#{node[:common][:libxslt]} -with-libxml-prefix=/usr/local/libxml2"
    not_if do File.exists?("/usr/local/libxslt-#{node[:common][:libxslt]}") end
  end

  link "/usr/local/libxslt" do
    to "/usr/local/libxslt-#{node[:common][:libxslt]}"
    only_if do File.exists?("/usr/local/libxslt-#{node[:common][:libxslt]}") end
  end

  execute "Cleanup libxslt" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/libxslt-#{node[:common][:libxslt]}"
  end
end
