case node[:platform]
when "centos","redhat","fedora"
  packages = %w{
    autoconf
    bison
    bzip2
    bzip2-libs
    bzip2-devel
    curl-devel
    emacs
    expat-devel
    flex
    freetype
    freetype-devel
    gdb
    gcc
    gcc-c++
    libdaemon
    libdaemon-devel
    libtool
    libxml2-devel
    libxslt
    libxslt-devel
    logwatch
    kernel-devel
    mlocate
    make
    nano 
    openssl
    openssl-devel
    patch
    pcre
    pcre-devel
    readline
    readline-devel
    screen
    subversion
    sudo
    unzip
    which
    zlib
    zlib-devel	
  }

  packages.each do |pkg|
    package pkg do
      action :install
      not_if "rpm -q #{pkg}"
    end
  end
when "ubuntu","debian"
  packages = %w{
    autoconf
    bison
    bzip2
    libbz2-1.0
    libbz2-dev
    libcurl3-dev
    emacs
    libexpat-dev
    flex
    libfreetype6
    libfreetype6-dev
    gdb
    gcc
    libdaemon0
    libdaemon-dev
    libtool
    libxml2-dev
    libxslt-dev
    libxslt1.1
    libxslt1-dev
    logwatch
    linux-headers-generic
    mlocate
    make
    nano
    libssl0.9.8
    openssl
    libssl-dev
    patch
    libpcre3
    libpcre3-dev
    libreadline5
    libreadline5-dev
    screen
    subversion
    sudo
    unzip
    zlib1g
    zlib1g-dev
  }

  packages.each do |pkg|
    package pkg do
      action :install
    end
  end
end

