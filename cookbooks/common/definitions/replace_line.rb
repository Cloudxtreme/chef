define :replace_line, :action => :enable do
  bash "replace_line #{params[:add]}" do
    code <<-EOH
      FIND="#{params[:find]}"
      ADD="#{params[:add]}"
      FILE="#{params[:file]}"

      if [ `grep "$ADD" $FILE | wc -l` -ge 1 ]; then
        echo "$ADD Entry already exists"
      elif [ `grep "$ADD" $FILE | wc -l` -eq 0 ]; then
        if [ `grep "$FIND" $FILE | wc -l` -eq 0 ]; then
          echo "$ADD" >> $FILE
        else
          sed -i "s@$FIND@$ADD@" $FILE
        fi
      else
	# why am i here? no file?
	echo ""
      fi
    EOH
    not_if do `/bin/grep "#{params[:add]}" #{params[:file]}`.length > 0 end
  end
end

