#!/bin/bash
# This script will update the Polycom Phones' contact directories
# from the mac addresses stored in the FreePBX Endpoint Manager
# and the Names in the Extensions/Users in FreePBX.
# 11/12/2013
# Eric Howey


#Settings

queue_result=`/usr/bin/mysql asterisk -N -B -e "SELECT DISTINCT LEFT(extension,4) FROM users WHERE extension LIKE '8%' AND name NOT RLIKE '^[0-9]' ORDER BY name ASC"`
extension_result=`/usr/bin/mysql asterisk -N -B -e "SELECT DISTINCT LEFT(extension,4) FROM users WHERE extension LIKE '3%' AND name NOT RLIKE '^[0-9]' ORDER BY name ASC"`
queues=(${queue_result,,})
extensions=(${extension_result,,})

i=1

for queue in "${queues[@]}"
do
   :
   name_result=`/usr/bin/mysql asterisk -N -B -e "SELECT name FROM users WHERE extension = '$queue'"`
   fullname=(${name_result})

   echo "attendant.resourceList.${i}.address=\"sip:${queue}@pbx.ltp.org\""
   echo "attendant.resourceList.${i}.label=\"${fullname[@]}\""
   echo "attendant.resourceList.${i}.type=\"normal\""
   echo ""
   let i++
done

for extension in "${extensions[@]}"
do
   :
   name_result=`/usr/bin/mysql asterisk -N -B -e "SELECT name FROM users WHERE extension = '$extension'"`
   fullname=(${name_result})
   
   echo "attendant.resourceList.${i}.address=\"sip:${extension}@pbx.ltp.org\""
   echo "attendant.resourceList.${i}.label=\"${fullname[@]}\""
   echo "attendant.resourceList.${i}.type=\"normal\""
   echo ""
   let i++
done

