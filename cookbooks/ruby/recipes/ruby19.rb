ruby_dir = "ruby-#{node[:ruby][:ruby19_version]}"
ruby_path = "/usr/local/#{ruby_dir}"

unless File.exists?(ruby_path)
  extract "#{ruby_dir}" do
    action :enable
  end

  build_src "#{ruby_dir}" do
    action :enable
    options "--prefix=#{ruby_path}"
    not_if do File.exists?("#{ruby_path}") end
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
