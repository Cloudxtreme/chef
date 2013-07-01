include_recipe "ruby::ruby18"

rubygems_dir = "rubygems-#{node[:ruby][:gems_version]}"
ruby_path = "/usr/local/ruby-#{node[:ruby][:ruby18_version]}"

unless File.exists?("#{ruby_path}/bin/gem")
  extract "#{rubygems_dir}" do
    action :enable
  end

  bash "rubygems" do
    code <<-EOH
      export PATH=#{ruby_path}/bin:$PATH
      pushd #{node[:common][:tmp_dir]}/#{rubygems_dir} >/dev/null
      ruby setup.rb
      popd >/dev/null
      gem install rubygems-update
      gem update --system
    EOH
  end

  execute "cleanup rubygems" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/#{rubygems_dir}"
    action :run
  end
end
