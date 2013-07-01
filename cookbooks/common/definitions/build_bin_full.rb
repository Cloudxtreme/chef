define :build_bin_full, :action => :enable do
  extract "#{params[:name]}" do
    action :enable
  end

  ins_dest = params[:install_dest]

  build_bin "#{params[:name]}" do
    action :enable
    install_dir "#{ins_dest}"
  end

  link "#{params[:symlink]}" do
    to "#{params[:install_dest]}"
    not_if "[ -z \"#{params[:symlink]}\" ]||[ -L \"#{params[:symlink]}\" ]"
  end

  execute "chown #{params[:install_dest]}" do
    command "chown -R #{params[:user]}.#{params[:group]} #{params[:install_dest]}"
  end

  execute "chown #{params[:install_dest]}" do
    command "chmod -R g+w #{params[:install_dest]}"
  end

  execute "cleanup #{params[:name]}" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/#{params[:name]}"
  end
end
