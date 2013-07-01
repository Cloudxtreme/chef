package "couchdb"

directory "/var/lib/couchdb" do
  owner "couchdb"
  group "couchdb"
  recursive true
end

service "couchdb" do
  supports :restart => true, :status => true
  action :enable
end
