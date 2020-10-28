#!/bin/bash
source /home/gor/easy_console/VARIABLE
export > /home/gor/easy_console/VARIABLE
echo "Checking Data sanity on Core Server"
data_sanity=`sudo /opt/butler_server/erts-9.3.3.6/bin/escript /home/gor/easy_console/data_sanity.escript  | awk -F[\(\)] '{print $2}'`
data_domain=`sudo /opt/butler_server/erts-9.3.3.6/bin/escript /home/gor/easy_console/data_validation.escript  | awk -F[\(\)] '{print $2}'`
echo "Data sanity is : " $data_sanity
echo "Data domain_validation function is : " $data_domain

echo "###############################################################################"
echo "Restarting Butler Server"
echo "###############################################################################"

if [ "$data_sanity" == "true" ] && [ "$data_domain" == "true" ]; then
	echo "Data sanity is true, Restarting Butler server is safe"
	sudo service butler_server stop
	sleep 2
	sudo service butler_server start
	sleep 2
	echo "####################################################"
	echo "Check logs for Butler server status"
	echo "####################################################"
	echo ""
	echo "####################################################"
	echo "Also Run After Butler Server Restart Script"
        echo "####################################################"

else
	echo "Data sanity is FALSE, SKIPPING Butler Server Restart"
fi
