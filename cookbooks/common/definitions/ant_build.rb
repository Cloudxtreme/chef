define :ant_build, :action => :enable do
bash "ant_build" do
  code <<-EOH
  source /etc/bashrc
  APP=$1
  STD_INSTALL_DIR=$2

  for j in 'ant clean build' 'ant buildbinary' 'ant dbupdate';
   do
    echo "$j"
    $j
    RETVAL=$?
    if [ $RETVAL = 1 ]; then
     echo "$j failed...Exiting"
     return
    elif [ $RETVAL = 0 ]; then
     echo
    else
     echo $RETVAL
     echo "Unknown response...Exiting"
     return
    fi
   done

   if [ -f build/binary/$APP.war ]; then
    echo "Adding $APP.war"
    sudo cp build/binary/$APP.war $STD_INSTALL_DIR
   fi
  EOH
end
end
