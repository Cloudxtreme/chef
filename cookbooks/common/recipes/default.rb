include_recipe "common::locale"
include_recipe "common::directories"
include_recipe "common::users"

case node[:platform]
when "centos","redhat","fedora"
  package "wget" do
    action :install
    not_if "rpm -q wget"
  end
when "ubuntu","debian"
  package "wget" do
    action :install
  end
end

execute "get resource list" do
  command "wget -O #{node[:common][:resource_list]} #{node[:common][:host]}/resource.list"
end

include_recipe "common::packages"
