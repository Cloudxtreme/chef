include_recipe "imagemagick::jpeg_module"

unless File.exists?("/usr/local/ImageMagick-#{node[:imagemagick][:version]}")
  extract "ImageMagick-#{node[:imagemagick][:version]}" do
    action :enable
  end

  build_src "ImageMagick-#{node[:imagemagick][:version]}" do
    action :enable
    options "--prefix=/usr/local/ImageMagick-#{node[:imagemagick][:version]} --with-freetype=yes 'CPPFLAGS=-I/usr/local/ImageMagick-#{node[:imagemagick][:version]}/include' 'LDFLAGS=-L/usr/local/ImageMagick-#{node[:imagemagick][:version]}/lib -R/usr/local/ImageMagick-#{node[:imagemagick][:version]}/lib'"
  end

  execute "cleanup ImageMagick" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/ImageMagick-#{node[:imagemagick][:version]}"
  end
end

unless File.exists?("/usr/local/ImageMagick-#{node[:imagemagick][:version]}/config")
  extract "imagemagick_config-#{node[:imagemagick][:config_version]}" do
    action :enable
  end

  execute "create ImageMagick config" do
    command "mv #{node[:common][:tmp_dir]}/config /usr/local/ImageMagick-#{node[:imagemagick][:version]}/"
  end
end

link "/usr/local/ImageMagick" do
  to "/usr/local/ImageMagick-#{node[:imagemagick][:version]}"
  not_if "[ -L /usr/local/ImageMagick ]"
end

template "/etc/profile.d/imagemagick.sh" do
  source "imagemagick.sh.erb"
  backup 0
  mode 0755
  owner "root"
  group "root"
end
