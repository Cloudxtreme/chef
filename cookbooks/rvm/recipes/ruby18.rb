include_recipe "rvm"

bash "rvm install ruby #{node[:rvm][:ruby18_version]}" do
  code <<-EOH
    if [ -f /etc/debian_version ]; then
      source /etc/bash.bashrc
    else
      source /etc/bashrc
    fi

    source $rvm_path/scripts/rvm

    rvm install #{node[:rvm][:ruby18_version]}
    rvm	#{node[:rvm][:ruby18_version]}@global
    echo Y | gem uninstall rake  
  EOH
  not_if "source /etc/bashrc; [[ -d \"$rvm_path/rubies/ruby-#{node[:rvm][:ruby18_version]}\" ]]"
end
