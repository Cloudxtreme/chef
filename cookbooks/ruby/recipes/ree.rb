ruby_dir = "ruby-enterprise-#{node[:ruby][:ree_version]}"
ruby_path = "/usr/local/#{ruby_dir}"

unless File.exists?(ruby_path)
  extract ruby_dir do
    action :enable
  end

  bash "install #{ruby_dir}" do
    code <<-EOH
      pushd #{node[:common][:tmp_dir]}/#{ruby_dir}
      ./installer --auto="#{ruby_path}"
      popd
    EOH
  end 

  execute "cleanup ruby" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/#{ruby_dir}"
    action :run
  end
end

link "/usr/local/ruby" do
  to "#{ruby_path}"
  not_if "[ -L /usr/local/ruby ]"
end

