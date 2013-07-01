group "postfix" do
  gid 3000
end

group "postdrop" do
  gid 3001
end

user "postfix" do
  gid "postfix"
  uid 3000
  home "/home/postfix"
  supports :manage_home => false
  shell "/bin/bash"
end

unless File.exists?("/usr/local/postfix#{node[:postfix][:total]}/sbin/postfix")
  package "db4-devel" do
    action :install
  end

  extract "postfix-#{node[:postfix][:version]}" do
    action :enable
  end
 
  (1..node[:postfix][:total].to_i).each do |i|
    unless File.exists?("/usr/local/postfix#{i}/etc")
      %x[mkdir -p /usr/local/postfix#{i}/etc]
    end

    template "/usr/local/postfix#{i}/etc/main.cf" do
      source "main.cf.multi.erb"
      variables :number => i
      not_if "[ -f /usr/local/postfix#{i}/etc/main.cf ]"
    end
  end

  cookbook_file "#{node[:common][:tmp_dir]}/postfix-#{node[:postfix][:version]}/make.sh" do
    source "make.sh"
  end

  bash "build #{node[:postfix][:total]} postfixes" do
    code <<-EOH
      pushd "#{node[:common][:tmp_dir]}/postfix-#{node[:postfix][:version]}" >/dev/null
      sh make.sh #{node[:postfix][:total]}
      popd >/dev/null
    EOH
    not_if "[ -f /usr/local/postfix#{node[:postfix][:total]}/sbin/postfix ]"
  end
  
  template "/etc/init.d/postfix.multi" do
    source "postfix.multi.erb"
    mode 0755
  end

  service "postfix.multi" do 
    action :enable
  end

  ruby_block "Create postfix.rc" do
    block do
      File.open("/etc/postfix.rc", 'a') do |f|
        (1..node[:postfix][:total].to_i).each { |i| f.puts "postfix#{i}" }
      end
    end
    not_if "[ -f /etc/postfix.rc ]"
  end

  execute "rebuild aliases" do
    command "/usr/local/postfix#{node[:postfix][:total]}/bin/newaliases"
    only_if "[ ! -f /etc/aliases.db ]||[ /etc/aliases -nt /etc/aliases.db ]"
  end

  execute "postfix cleanup" do
    command "/bin/rm -rf #{node[:common][:tmp_dir]}/postfix-#{node[:postfix][:version]}"
  end
end
