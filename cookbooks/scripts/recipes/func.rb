node[:scripts][:functions][:users].each do |user|
  directory "/home/#{user}/scripts" do
    owner "#{user}"
    group "#{user}"
    mode 0755
    recursive true
  end

  directory "/home/#{user}/scripts/functions" do
    owner "#{user}"
    group "#{user}"
    mode 0755
    recursive true
  end

  directory "/home/#{user}/logs" do
    owner "#{user}"
    group "#{user}"
    mode 0755
    recursive true
  end

  template "/home/#{user}/scripts/funcs.sh" do
    source "funcs.sh.erb"
    owner "#{user}"
    group "#{user}"
    mode 0755
  end

  node[:scripts][:functions][:"#{user}"].each do |script|
    template "/home/#{user}/scripts/functions/#{script}" do
      source "#{user}/functions/#{script}.erb"
      owner "#{user}"
      group "#{user}"
      mode 0700
    end
  end
end

