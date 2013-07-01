default[:php][:current] = "5.2.10"
default[:php][:version] = "5.2.17" # next 5.2.10
default[:php][:fpm_version] = "0.5.14" # next 0.5.11
default[:php][:apc_version] = "3.0.19"
default[:php][:ini_file] = "/usr/local/lib/php.ini"
default[:php][:imagick_version] = "2.1.1"
default[:php][:re2c_version] = "0.13.5"
default[:php][:extension_dir] = "/usr/local/php-#{default[:php][:version]}/lib/php/extensions/no-debug-non-zts-20060613"
default[:php][:default_flags] = "--with-mysql=/usr/local/mysql --with-config-file-path=/usr/local/lib --with-openssl --with-curl --enable-mbstring"
default[:php][:fcgi_flags] = "--enable-fastcgi --enable-force-cgi-redirect"
default[:php][:fcgi] = false

default[:php53][:dir]     = "/usr/local/php"
default[:php53][:version] = "5.3.8"
default[:php53][:apc_version] = "3.1.4"
default[:php53][:imagick_version] = "3.0.0"
default[:php53][:re2c_version] = "0.13.5"
default[:php53][:suhosin_patch_version] = "0.9.10"
default[:php53][:extension_dir] = "/usr/local/php-#{default[:php53][:version]}/lib/php/extensions/no-debug-non-zts-20090626"
default[:php53][:ini_file] = "/usr/local/php-#{default[:php53][:version]}/etc/php.ini"
