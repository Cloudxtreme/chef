case node[:platform]
when "centos","redhat","fedora"
  packages = {
    "p7zip-9.20.1-2.el5" => node[:common][:p7zip],
    "p7zip-plugins-9.20.1-2.el5" => node[:common][:p7zip_plugin]
  }

  package "p7zip" do
    action :upgrade
    version "9.20.1"
  end

  package "p7zip-plugins" do
    action :upgrade
    version "9.20.1"
  end
when "ubuntu","debian"
  packages = %w{
    p7zip
    p7zip-full
  }

  packages.each do |pkg|
    package pkg do
      action :install
    end
  end
end
