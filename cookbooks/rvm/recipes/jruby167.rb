include_recipe "rvm"

bash "rvm install jruby-1.6.7" do
  code <<-EOH
    source /usr/local/rvm/scripts/rvm
    rvm install jruby-1.6.7
  EOH
  not_if "[ -d \"/usr/local/rvm/rubies/jruby-1.6.7\" ]"
end
