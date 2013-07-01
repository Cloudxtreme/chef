define :add_line, :action => :enable do
  bash "add_line #{params[:add]}" do
  code <<-EOH
    FIND="#{params[:find]}"
    ADD="#{params[:add]}"
    FILE="#{params[:file]}"
    LINE="#{params[:line]}"

    if ! $(grep -q "$FIND" $FILE); then
      if [ -n "$LINE" ]; then
        sed -i "${LINE}i $ADD" $FILE
      else
        echo "$ADD" >> $FILE
      fi
    fi
  EOH
  not_if "/bin/grep \"#{params[:add]}\" #{params[:file]}"
  end
end
