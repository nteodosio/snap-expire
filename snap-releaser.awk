{
    gsub("\\\\t", " ")
    gsub(/"/, "")
}
# Not a valid revision number? Ignore line.
$NF !~ /^[0123456789]+$/{
   print("Line >>", $NF, "<< does not have a valid revision number, skipping") > "/dev/stderr"
   next
}
{
   "datediff -f %d " today " " $2 | getline daysTilExpires
   if (daysTilExpires <= 1) {
       data=sprintf("{\042name\042:\042%s\042,\042revision\042:%d,\042channels\042:[\042%s\042]}", $1, $NF, $(NF-1))
       system("surl -a " $1 " -s production -d '" data "'" FS url)
   }
}
