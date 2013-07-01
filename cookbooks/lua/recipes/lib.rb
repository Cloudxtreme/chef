unless File.exists?("/usr/local/lua#{node[:lua][:lib_version]}_lib")
  extract "lua#{node[:lua][:lib_version]}_lib" do
    action :enable
  end

  execute "Build lua#{node[:lua][:lib_version]}_lib" do
    command "mv \"#{node[:common][:tmp_dir]}/lua#{node[:lua][:lib_version]}_lib\" /usr/local/"
    not_if "[ -d /usr/local/lua#{node[:lua][:lib_version]}_lib ]"
  end 

  execute "Cleanup lua#{node[:lua][:lib_version]}_lib" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/lua#{node[:lua][:lib_version]}_lib"
  end
end

link "/usr/local/lib-lua" do
  to "/usr/local/lua#{node[:lua][:lib_version]}_lib"
  not_if "[ -L /usr/local/lib-lua ]" 
end


