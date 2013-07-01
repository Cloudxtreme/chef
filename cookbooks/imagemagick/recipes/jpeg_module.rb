unless File.exists?("/usr/local/ImageMagick-#{node[:imagemagick][:version]}/lib/libjpeg.so")
  extract "#{node[:imagemagick][:jpeg_version]}" do
    action :enable
  end

  build_src "#{node[:imagemagick][:jpeg_version]}" do
    action :enable
    options "--prefix=/usr/local/ImageMagick-#{node[:imagemagick][:version]}"
  end

  execute "cleanup jpeg_module" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/#{node[:imagemagick][:jpeg_version]}"
  end
end

