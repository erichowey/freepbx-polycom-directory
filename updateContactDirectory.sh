#!/bin/bash
# This script will update the Polycom Phones' contact directories
# from the mac addresses stored in the FreePBX Endpoint Manager
# and the Names in the Extensions/Users in FreePBX.
# 11/12/2013
# Eric Howey


#Settings


mac_result=`/usr/bin/mysql asterisk -N -B -e "SELECT mac FROM endpointman_mac_list"`
extension_result=`/usr/bin/mysql asterisk -N -B -e "SELECT LEFT(extension,4) FROM users WHERE extension LIKE '3%' ORDER BY name ASC"`

macs=(${mac_result,,})
extensions=(${extension_result,,})

rm -f /tftpboot/contacts/0004*
rm -f /tftpboot/contacts/master.xml
rm -f /home/ltp/contacts/*

out="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n"
out=${out}"<!-- \$RCSfile: 000000000000-directory~.xml,v $  \$Revision: 1.3 $ -->\n"
out=${out}"<directory>\n"
out=${out}"<item_list>\n"


for extension in "${extensions[@]}"
do
   :
   name_result=`/usr/bin/mysql asterisk -N -B -e "SELECT name FROM users WHERE extension = '$extension'"`
   fullname=(${name_result})
   
   out=${out}"<item>\n"
   out=${out}"<fn>${fullname[0]}</fn>\n"
   out=${out}"<ln>${fullname[@]:1}</ln>\n"
   out=${out}"<ct>${extension}</ct>\n"
   out=${out}"</item>\n"
done

out=${out}"</item_list>\n"
out=${out}"</directory>\n"

echo -e $out > /tftpboot/contacts/master.xml

for mac in "${macs[@]}"
do
   :
   cp /tftpboot/contacts/master.xml /tftpboot/contacts/${mac}-directory.xml
   cp /tftpboot/contacts/master.xml /home/ltp/contacts/${mac}-directory.xml
done

chmod 777 /tftpboot/contacts/*

