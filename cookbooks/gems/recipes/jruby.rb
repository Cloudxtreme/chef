cookbook_file "#{node[:common][:archive]}/jgems.list" do
  source "jgems.list"
end

ruby_block "install jruby gems" do
  block do
    def options(gem)
      if gem == "mysql"
        "-- --with-mysql-config=/usr/local/mysql/bin/mysql_config"
      else
        ""
      end
    end

    def install_gems(current, new)
      jgem = "PATH=$PATH:/usr/local/java/bin:/usr/local/jruby/bin jgem"

      new.each do |gem,versions|
        versions.each do |v|
          if current.include?(gem) == false || current[gem].include?(v) == false
            `#{jgem} install #{gem} -v=#{v} --no-ri --no-rdoc #{options(gem)}`
          end
        end
      end
    end

    jgem = "PATH=$PATH:/usr/local/java/bin:/usr/local/jruby/bin jgem"
    currentgems = {}
    newgems = {}
    `cat #{node[:common][:archive]}/jgems.list`.split("\n").map { |x| newgems[x.split(" ",2).first] = x.split(" ",2).last.split }
    `#{jgem} list`.split("\n").map { |x| currentgems[x.split(" ", 2).first] = x.split(" ", 2).last.gsub(/[()\s]/,"").split(",") }
 
    install_gems(currentgems,newgems)
  end
end

