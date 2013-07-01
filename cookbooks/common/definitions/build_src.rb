define :build_src, :action => :enable do
bash "build_src #{params[:name]}" do
  code <<-EOH
    echo "Building #{params[:name]} with opts: #{params[:options]}"
    pushd #{node[:common][:tmp_dir]}/#{params[:name]}
    ./configure #{params[:options]}
    PROCS=`egrep ^processor /proc/cpuinfo | wc -l`; let PROCS+=1;
    make -j $PROCS
    sudo make install
    popd
  EOH
end
end
