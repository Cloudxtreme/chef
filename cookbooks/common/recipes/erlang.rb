if ! File.exists?("/usr/local/otp_src_#{node[:common][:erlang]}")
  extract "otp_src_#{node[:common][:erlang]}" do
    action :enable
  end

  build_src "otp_src_#{node[:common][:erlang]}" do
    action :enable
    options "--prefix=/usr/local/otp_src_#{node[:common][:erlang]}"
    not_if do File.exists?("/usr/local/otp_src_#{node[:common][:erlang]}") end
  end

  link "/usr/local/erlang" do
    to "/usr/local/otp_src_#{node[:common][:erlang]}"
    only_if do File.exists?("/usr/local/otp_src_#{node[:common][:erlang]}") end
  end

  execute "Cleanup erlang" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/otp_src_#{node[:common][:erlang]}"
  end
end
