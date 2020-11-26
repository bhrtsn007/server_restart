#!/bin/bash
DATE=`date`
echo "###############################################################################"
echo "Restart script call at $DATE"
echo "###############################################################################"
echo ""
echo "Checking Data sanity on Core Server"
data_sanity=`sudo /opt/butler_server/erts-9.3.3.6/bin/escript /home/gor/easy_console/server_restart/data_sanity.escript  | awk -F[\(\)] '{print $2}'`
data_domain=`sudo /opt/butler_server/erts-9.3.3.6/bin/escript /home/gor/easy_console/server_restart/data_validation.escript  | awk -F[\(\)] '{print $2}'`
echo "Data sanity is : " $data_sanity
echo "Data domain_validation function is : " $data_domain

echo "###############################################################################"
echo "Restarting Butler Server"
echo "###############################################################################"

if [ "$data_sanity" == "true" ] && [ "$data_domain" == "true" ]; then
	echo "Data sanity is true, Restarting Butler server is safe"
	echo ""
	echo "please enter your name:"
	read name
	echo "$name please type 'Yes' for confirming and 'No' for aborting the process:"
	read confirmation
	if [ "$confirmation" == "Yes" ]; then
		echo "Stopping Butler server"
		sudo systemctl stop butler_server.service
		echo "Checking active PID"
		sleep 20
		pid_check_1=`pgrep -af "butler_server -mode"`
		echo "PID found: $pid_check_1"
		if [ ! -n "$pid_check_1" ]; then
			echo "Server Stop successfully, starting butler_server application"
			sudo systemctl start butler_server.service
			sleep 5
			echo "Restart complete"
		else
			echo "Server not stopped properly, trying to kill active PID"
			sudo pkill -f "butler_server -mode"
			echo "Checking active PID again"
			sleep 20
			pid_check_2=`pgrep -af "butler_server -mode"`
			echo "PID found: $pid_check_2"
			if [ ! -n "$pid_check_2" ]; then
				echo "Server stop successfully after clearing PID, starting butler_server application"
				sudo systemctl start butler_server.service
	            sleep 5
				echo "Restart complete"
			else
				echo "Server not stopped after killing PID, killing butler_server PID forcefully"
				sudo pkill -9 -f "butler_server -mode"
				sleep 20
				echo "forcefull kill complete, Checking active PID again"
				pid_check_3=`pgrep -af "butler_server -mode"`
				echo "PID found: $pid_check_3"
				if [ ! -n "$pid_check_3" ]; then
					echo "Server stop successfully after clearing PID forcefully, starting butler_server application"
					sudo systemctl start butler_server.service
					sleep 5
					echo "Restart complete"
				else
					echo "Something still wrong, check all PID which are active and then start butler_server application manually"
				fi
			fi
			
		fi
		echo "####################################################"
		echo "Check logs for Butler server status"
		echo "####################################################"
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
