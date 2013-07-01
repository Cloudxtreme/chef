include_recipe "rvm"

bash "rvm install ruby-#{node[:rvm][:ruby19_version]}" do
  code <<-EOH
    source /usr/local/rvm/scripts/rvm

    rvm install ruby-#{node[:rvm][:ruby19_version]}
    rvm	ruby-#{node[:rvm][:ruby19_version]}@global
    echo Y | gem uninstall rake  
  EOH
  not_if "[ -d \"/usr/local/rvm/rubies/ruby-#{node[:rvm][:ruby19_version]}\" ]"
end
