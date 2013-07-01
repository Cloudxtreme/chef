define :build_php, :action => :enable do
    extract "php-#{node[:php][:version]}" do
      action :enable
    end

    cookbook_file "#{node[:common][:archive]}/php-#{node[:php][:version]}-fpm-#{node[:php][:fpm_version]}.diff.gz" do
      source "php-#{node[:php][:version]}-fpm-#{node[:php][:fpm_version]}.diff.gz"
    end

    fpm_pkg = "php-#{node[:php][:version]}-fpm-#{node[:php][:fpm_version]}"
    execute "fpm patch" do
      command "gzip -cd #{node[:common][:archive]}/#{fpm_pkg}.diff.gz | patch -d #{node[:common][:tmp_dir]}/php-#{node[:php][:version]} -p1"
      only_if do params[:fpm] end
    end

    php_opts = params[:options]

    build_src "php-#{node[:php][:version]}" do
      action :enable
      options "#{php_opts}"
      not_if "[ -d /usr/local/php-#{node[:php][:version]} ]"
    end

    template "#{node[:php][:ini_file]}" do
      source "php.ini.erb"
      mode "0644"
      variables ({
      :mem_limit => "24M",
      :extension_dir => "/usr/local/php/lib/php/extensions/"
      })
    end
                
    extract "Zend" do
      action :enable
      not_if "[ -d /usr/local/php-#{node[:php][:version]}/lib/php/Zend ]"
    end

    execute "Install Zend" do
      command "mv #{node[:common][:tmp_dir]}/Zend /usr/local/php-#{node[:php][:version]}/lib/php/"
      not_if "[ -d /usr/local/php-#{node[:php][:version]}/lib/php/Zend ]"
    end

    execute "cleanup php" do
      command "/bin/rm -rf #{node[:common][:tmp_dir]}/php-#{node[:php][:version]}"
      action :run
    end
end
