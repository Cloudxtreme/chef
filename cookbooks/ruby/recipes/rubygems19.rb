include_recipe "ruby::ruby19"

rubygems_dir = "rubygems-#{node[:ruby][:gems_version]}"
ruby_dir = "/usr/local/ruby-#{node[:ruby][:ruby19_version]}"

unless File.exists?("#{ruby_dir}/bin/gem")
  extract "#{rubygems_dir}" do
    action :enable
  end

  bash "rubygems" do
    code <<-EOH
      export PATH=#{ruby_dir}/bin:$PATH
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
