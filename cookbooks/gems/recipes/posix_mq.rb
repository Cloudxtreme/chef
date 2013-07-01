unless File.exists?("/usr/local/ruby/bin/posix-mq-rb")
  extract "ruby_posix_mq" do
    action :enable
  end

  bash "Build ruby_posix_mq" do
    code <<-EOH
    pushd "#{node[:common][:tmp_dir]}/ruby_posix_mq"
    /usr/local/ruby/bin/ruby setup.rb all
    popd
    EOH
  end

  execute "Cleanup ruby_posix_mq" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/ruby_posix_mq"
  end
end
