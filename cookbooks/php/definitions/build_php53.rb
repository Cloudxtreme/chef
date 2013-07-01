define :build_php53, :action => :enable do
  unless File.exists?("/usr/local/php-#{node[:php53][:version]}")
    extract "php-#{node[:php53][:version]}" do
      action :enable
    end

    install_options = params[:install_options]

    build_src "php-#{node[:php53][:version]}" do
      action :enable
      options "#{install_options}"
    end

    template "/usr/local/php-#{node[:php53][:version]}/etc/php.ini" do
      source "php53.ini.erb"
      mode "0644"
      variables ({
      :mem_limit => "24M",
      :extension_dir => "#{node[:php53][:extension_dir]}"
      })
    end

    execute "create /etc/init.d/php53-fpm" do
      command "cp #{node[:common][:tmp_dir]}/php-#{node[:php53][:version]}/sapi/fpm/init.d.php-fpm /etc/init.d/php53-fpm"
      umask 022
      only_if "[ -f #{node[:common][:tmp_dir]}/php-#{node[:php53][:version]}/sapi/fpm/init.d.php-fpm ]"
    end

    execute "cleanup php" do
      command "/bin/rm -rf #{node[:common][:tmp_dir]}/php-#{node[:php53][:version]}"
    end
  end
end
