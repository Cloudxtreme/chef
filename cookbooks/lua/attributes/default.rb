case kernel[:machine]
when "x86_64"
    default[:lua][:lib_version] = "5_1_4_Linux26g4_64"
when "i686"
    default[:lua][:lib_version] = "5_1_4_Linux26g4"
end
