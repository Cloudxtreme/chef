define :build_bin, :action => :enable do
  execute "build_bin #{params[:install_dir]}" do
    command "mv \"#{node[:common][:tmp_dir]}/#{params[:name]}\" \"#{params[:install_dir]}\""
    not_if "[[ -d #{params[:install_dir]} ]]"
  end
end
