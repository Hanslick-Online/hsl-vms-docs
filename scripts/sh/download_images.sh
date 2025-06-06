#!/bin/bash
colId=1944511
SRC=`dirname "$0"`/../../../../TranskribusPyClient/src

#PYTHON=python
PYTHON=python

function error {
	echo -e "\e[31mERROR\e[0m:\t$1\n"
	exit 1
}

function isok {
	if [[ $1 = 1 ]] ; then
		echo -e "[\e[31mERROR\e[0m]\t$2\n"
		exit 1
	else
		echo -e "[\e[32mOK\e[0m]\t$1"
	fi
}


#cleaning any persistent login info
tmp_col_id=`$PYTHON $SRC/TranskribusCommands/do_logout.py --persist`  && isok "cleaning" || isok 1  "cleaning error"

#making a login and persisting the session token
tmp_col_id=`$PYTHON $SRC/TranskribusCommands/do_login.py --persist -l $TR_USER -p $TR_PW` && isok "login" || isok 1  "login"

rm -rf trnskrbs_$colId  && isok "clean up" || isok 1 "delete error trnskrbs_${colId}"

$PYTHON $SRC/TranskribusCommands/Transkribus_downloader.py $colId --persist && isok "download" || isok 1 "download error"

echo "moving transkribus export jpg to facs dir…"
for i in ./trnskrbs_${colId}/col/*/*.jpeg ; do
	mv "${i}" ./data/facs/"`echo $i|cut -d / -f 5 | sed 's/jpeg$/jpg/'`" && isok "${i}" || isok 1 "mv error ${i}"
done
echo -e "\n\n* DONE *"
