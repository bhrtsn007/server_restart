#!/bin/bash
DATE=`date`
echo "###############################################################################"
echo "Restart script call at $DATE"
echo "###############################################################################"
echo ""
echo "Checking Data sanity on Core Server"
data_sanity=`sudo /opt/butler_server/erts-9.3.3.6/bin/escript /home/gor/easy_console/server_restart/data_sanity.escript  | awk -F[\(\)] '{print $2}'`
echo "Data sanity is : " $data_sanity

echo "###############################################################################"
echo "Restarting Butler Server"
echo "###############################################################################"

if [ "$data_sanity" == "true" ]; then
	echo "Data sanity is true, Restarting Butler server is safe"
	echo ""
	echo "please enter your name:"
	read name
	echo "$name please type 'Yes' for confirming and 'No' for aborting the process:"
	read confirmation
	if [ "$confirmation" == "Yes" ]; then
		sudo service butler_server stop
		sleep 2
		sudo service butler_server start
		sleep 2
		echo "####################################################"
		echo "Check logs for Butler server status"
		echo "####################################################"
		echo ""
		echo "Restarting Done"
		echo ""
		echo "####################################################"
		echo "Also Run After Butler Server Restart Script"
	        echo "####################################################"
	elif [ "$confirmation" == "No" ];then
		echo "Aborted Butler server restart"
	else
		echo "Wrong Input"
	fi

else
	echo "Data sanity is FALSE, SKIPPING Butler Server Restart"
fi
