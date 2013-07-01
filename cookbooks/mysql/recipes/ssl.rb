directory "/etc/mysql/certs" do
  recursive true
  mode 0750
  owner "root"
  group "mysql"
end

bash "create certificates" do
  cwd "/etc/mysql/certs"
  code <<-EOH
    # create ca
    openssl genrsa 2048 > ca-key.pem
    openssl req -new -x509 -nodes -days 3650 -subj '/CN=mysql/O=Example.com Ltd/C=GB/ST=London/L=London' \
    -key ca-key.pem -out ca-cert.pem

    # create server key
    openssl req -newkey rsa:2048 -days 3650 -nodes -subj '/CN=mysql/O=Example.com Ltd/C=GB/ST=London/L=London' \
    -keyout server-key.pem -out server-req.pem
    openssl rsa -in server-key.pem -out server-key.pem

    # create server cert
    openssl x509 -req -in server-req.pem -days 3650 -CA ca-cert.pem -CAkey ca-key.pem \
    -set_serial 01 -out server-cert.pem

    # create client keys
    openssl req -newkey rsa:2048 -days 3650 -nodes -subj '/CN=mysql/O=Example.com Ltd/C=GB/ST=London/L=London' \
    -keyout client-key.pem -out client-req.pem

    openssl rsa -in client-key.pem -out client-key.pem
    openssl x509 -req -in client-req.pem -days 3650 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem

    openssl verify -CAfile ca-cert.pem server-cert.pem client-cert.pem
  EOH
  not_if "[ -f /etc/mysql/certs/server-cert.pem ]"
end
