include_recipe "rvm"

bash "rvm install ree #{node[:rvm][:ree_version]}" do
  code <<-EOH
    if [ -f /etc/debian_version ]; then
      source /etc/bash.bashrc
    else
      source /etc/bashrc
    fi

    source $rvm_path/scripts/rvm

    rvm install ree-#{node[:rvm][:ree_version]}
    rvm ree-#{node[:rvm][:ree_version]}@global
    echo Y | gem uninstall rake
  EOH
  not_if "[ -d \"/usr/local/rvm/rubies/ree-#{node[:rvm][:ree_version]}\" ]"
end
