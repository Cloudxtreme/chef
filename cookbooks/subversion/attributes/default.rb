
case platform
when "centos","redhat","fedora"
  if kernel[:machine] == "x86_64"
    default[:subversion][:rpmforge] = "http://apt.sw.be/redhat/el5/en/x86_64/rpmforge/RPMS//rpmforge-release-0.3.6-1.el5.rf.x86_64.rpm"
  elsif kernel[:machine] == "i686"
    default[:subversion][:rpmforge] = "http://apt.sw.be/redhat/el5/en/i386/rpmforge/RPMS/rpmforge-release-0.3.6-1.el5.rf.i386.rpm"
  end
end
