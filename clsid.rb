a=0
File.open("c:\\clsid-dist.txt",'w') do |f|
  File.open("c:\\CLSID.txt").each do |line|
    if line.length>0 then
      (desp,clsid)=line.split(".")
      clsid=clsid.chop()
      f.write "HiddenRecord[#{a}].Description := '#{desp}';"+"\n"
      f.write "HiddenRecord[#{a}].clsid := '#{clsid}';"+"\n"
      f.write "\n"
      a=a+1
    end
  end
end