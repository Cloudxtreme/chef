define :extract, :action => :enable do
bash "get #{params[:name]}" do
  code <<-EOH
  PKG=`grep "^#{params[:name]}\\." "#{node[:common][:resource_list]}" | head -n 1`
  if [ ! -f "#{node[:common][:archive]}/$PKG" ]; then
    pushd "#{node[:common][:archive]}"
    wget "#{node[:common][:host]}/$PKG" --no-check-certificate
    popd
  fi
  EOH
end

bash "extract #{params[:name]}" do
  code <<-EOH  
    if [ -z "#{params[:name]}" ]; then
      return 1
    else
      STD_PACKAGE="#{params[:name]}"
    fi

    if [ ! -d "#{node[:common][:tmp_dir]}" ]; then
      mkdir "#{node[:common][:tmp_dir]}"
    fi

    pushd "#{node[:common][:tmp_dir]}" >/dev/null

    # Remove Package if already exists
    if [ -d "#{node[:common][:tmp_dir]}/$STD_PACKAGE" ]; then
      /bin/rm -rf "#{node[:common][:tmp_dir]}/$STD_PACKAGE"
    fi
  
    # Extract Package
    if [ -f #{node[:common][:archive]}/$STD_PACKAGE.tar.gz ]; then
      tar zxf #{node[:common][:archive]}/$STD_PACKAGE.tar.gz
    elif [ -f #{node[:common][:archive]}/$STD_PACKAGE.tgz ]; then
      tar zxf #{node[:common][:archive]}/$STD_PACKAGE.tgz
    elif [ -f #{node[:common][:archive]}/$STD_PACKAGE.tar ]; then
      tar xf #{node[:common][:archive]}/$STD_PACKAGE.tar
    elif [ -f #{node[:common][:archive]}/$STD_PACKAGE.bz2 ]; then
      bzip2 -d #{node[:common][:archive]}/$STD_PACKAGE.bz2
    elif [ -f #{node[:common][:archive]}/$STD_PACKAGE.zip ]; then
      unzip #{node[:common][:archive]}/$STD_PACKAGE.zip
    elif [ -f #{node[:common][:archive]}/$STD_PACKAGE.tar.bz2 ]; then
      tar jxf #{node[:common][:archive]}/$STD_PACKAGE.tar.bz2
    else
      echo "Unknown STD_PACKAGE $STD_PACKAGE"
      return 1
    fi

    popd >/dev/null
  EOH
end
end
