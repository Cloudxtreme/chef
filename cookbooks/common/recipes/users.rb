if node[:common][:users][:create] && node[:common][:users][:use]
  list = node[:common][:users][:use]
  manage_homedir = node[:common][:users][:manage_home]

  node[:common][:users][:"#{list}"].each do |u,id|
    group "#{u}" do
      gid id
    end

    user "#{u}" do
      uid id
      gid id
      home "/home/#{u}"
      shell "/bin/bash"
      manage_home manage_homedir
      not_if "grep -qE \"^#{u}:\" /etc/passwd"
    end
  end
end 
