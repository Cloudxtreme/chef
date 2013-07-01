include_recipe "gems::dbi"
include_recipe "gems::dbd"

bash "add gem sources" do
  code <<-EOH
    for source in "http://svn.example.com:81" "http://gems.github.com" "http://gemcutter.org"; do
      if ! (/usr/local/ruby/bin/gem source --list | grep $source)>/dev/null; then 
	/usr/local/ruby/bin/gem source -a $source
      fi
    done
  EOH
end

cookbook_file "#{node[:common][:archive]}/gems.list" do
  source "gems.list"
end

ruby_block "install gems" do
  block do

    def options(gem)
      if gem == "mysql"
        "-- --with-mysql-config=/usr/local/mysql/bin/mysql_config"
      elsif gem == "nokogiri"
        if File.exists?("/usr/local/libxml2")
	  "-- --with-xml2-include=/usr/local/libxml2/include --with-xml2-lib=/usr/local/libxml2/lib  --with-xslt-dir=/usr/local/libxslt"
        end
      else
        ""
      end
    end

    def install_gems(current, new)
      new.each do |gem,versions| 
        versions.each do |v| 
          if current.include?(gem) == false || current[gem].include?(v) == false
            `/usr/local/ruby/bin/gem install #{gem} -v=#{v} --no-ri --no-rdoc #{options(gem)}`
          end
        end
      end
    end

    currentgems = {}
    newgems = {}
    `cat #{node[:common][:archive]}/gems.list`.split("\n").map { |x| newgems[x.split(" ",2).first] = x.split(" ",2).last.split }
    `/usr/local/ruby/bin/gem list`.split("\n").map { |x| currentgems[x.split(" ", 2).first] = x.split(" ", 2).last.gsub(/[()\s]/,"").split(",") }

    newgems['rubygems-update'].last do |version|
      if currentgems['rubygems-update'].include?(version) == false
        `/usr/local/ruby/bin/gem update --system`
      end
    end
    install_gems(currentgems,newgems)
  end
end
