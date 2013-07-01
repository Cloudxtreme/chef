define :install_rpm, :action => :enable do
  k = params[:k]
  v = params[:v]
  bash "install_rpm #{k}" do
    code <<-EOH
      if [ ! -f "#{node[:common][:archive]}/#{v}.rpm" ]; then
        pushd "#{node[:common][:archive]}" >/dev/null
        wget "#{node[:common][:host]}/#{v}.rpm" --no-check-certificate
        popd >/dev/null
      fi

      rpm -i "#{node[:common][:archive]}/#{v}.rpm"
    EOH
    not_if "rpm -q #{k} >/dev/null"
  end
end
