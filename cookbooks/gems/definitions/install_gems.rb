define :install_gems, :action => :enable do
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

    def inst_gems(current, new)
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
    File.read(params[:gem_list]).split("\n").map { |line| newgems[line.split(" ",2).first] = line.split(" ",2).last.split }
    `/usr/local/ruby/bin/gem list`.split("\n").map { |line| currentgems[line.split(" ", 2).first] = line.split(" ", 2).last.gsub(/[()\s]/,"").split(",") }

    if newgems['rubygems-update']
      `/usr/local/ruby/bin/gem update --system` unless currentgems['rubygems-update'].include?(newgems['rubygems-update'].last)
    end

    inst_gems(currentgems, newgems)
end
