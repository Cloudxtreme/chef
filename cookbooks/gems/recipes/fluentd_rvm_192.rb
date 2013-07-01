include_recipe "rvm::ruby19"

cookbook_file "#{node[:common][:archive]}/fluentd_rvm_192.gems" do
  source "fluentd_rvm_192.gems"
end

bash "import gemset #{node[:rvm]['ruby19_version']}@fluentd" do
  code <<-EOH
    source /etc/rvmrc 
    source $rvm_path/scripts/rvm
    rvm use #{node[:rvm]['ruby19_version']}@fluentd --create
    rvm gemset import #{node[:common][:archive]}/fluentd_rvm_192.gems
  EOH
end
