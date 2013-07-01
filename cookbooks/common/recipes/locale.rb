case node[:platform]
when "ubuntu","debian"
  directory "/etc/default/locale" do
    mode 0755
    owner "root"
    group "root"
  end

  template "/etc/default/locale/i18n" do
    source "i18n.erb"
    mode 0644
    owner "root"
    group "root"
  end
when "centos","redhat","fedora"
  template "/etc/profile.d/lang.sh" do
    source "lang.sh.erb"
    mode 0755
    owner "root"
    group "root"
  end

  template "/etc/sysconfig/i18n" do
    source "i18n.erb"
    mode 0644
    owner "root"
    group "root"
  end
end
