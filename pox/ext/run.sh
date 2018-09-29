
#!/bin/bash


TCPExperiment(){
	echo "*** Start TCP Experiment ***"

	#--------------------------------plot figure9
	echo "-----------Plot Figure 9-----------"
	sudo python graph-paths.py 
	echo "Figure OK"



	echo "-----------Start TCP Scenarios - Table 1-----------"

	# run 3 times de experiment 
	for i in 1 2 3;
	do
		#--------------------------------1flow_20servers_8shortest
		echo "-----------SCENARIO: 1flow_20servers_8shortest-----------"
		sudo mn -c
		sudo killall python
		sudo python 1flow_20servers_8shortest.py 

		#--------------------------------8flow_20servers_8shortest
		echo "-----------SCENARIO: 8flow_20servers_8shortest-----------"
		sudo mn -c
		sudo killall python
		sudo python 8flow_20servers_8shortest.py 

		#--------------------------------1flow_20servers_ECMP8
		echo "-----------SCENARIO: 1flow_20servers_ECMP-----------"
		sudo mn -c
		sudo killall python
		sudo python 1flow_20servers_ECMP.py 

		#--------------------------------8flow_20servers_ECMP8
		echo "-----------SCENARIO: 8flow_20servers_ECMP-----------"
		sudo mn -c
		sudo killall python
		sudo python 8flow_20servers_ECMP.py 
	done	


	echo "------------- Computing Average -----------"
	echo " "
	echo "------------- Topology Jellyfish (20 servers) "
	echo "------------- ECMP8 --------- 8_shortest path "	

	# read the file and show the second column after ':' from the first to the 14 character (all lines) and compute the average
	#cat average1flow-ECMP.txt | awk -F ":" '{soma+=$2} END {print substr($2, 1, 14)}'
	average1flowECMP=`cat average1flow-ECMP.dat | awk -F ":" '{soma+=substr($2, 1, 14)} END {media=soma/2} END {printf("%.2f",media)}'`
	average8flowECMP=`cat average8flow-ECMP.dat | awk -F ":" '{soma+=substr($2, 1, 14)} END {media=soma/2} END {printf("%.2f",media)}'`
	
	average1flow8shortest=`cat average1flow-8shortest.dat | awk -F ":" '{soma+=substr($2, 1, 14)} END {media=soma/2} END {printf("%.2f",media)}'` 
	average8flow8shortest=`cat average8flow-8shortest.dat | awk -F ":" '{soma+=substr($2, 1, 14)} END {media=soma/2} END {printf("%.2f",media)}'`
	
	echo "TCP 1 flow -- $average1flowECMP --------- $average1flow8shortest ---------"
	echo "TCP 8 flow -- $average8flowECMP --------- $average8flow8shortest ---------"
	echo " "
	echo "*** Finished TCP Experimet ((; ***"
}


MPTCPExperiment()
{

	echo "*** Start MPTCP Experiment ***"

	#--------------------------------plot figure9
	echo "-----------Plot Figure 9-----------"
	sudo python graph-paths.py 
	echo "Figure OK"


	echo "-----------Start MPTCP Scenarios - Table 1-----------"

	# run 3 times de experiment 
	for i in 1 2 3;
	do
		#--------------------------------8flow_20servers_8shortest
		echo "-----------SCENARIO: 8flow_20servers_8shortest-----------"
		sudo mn -c
		sudo killall python
		sudo python 8flow_20servers_8shortest.py 

		#--------------------------------8flow_20servers_ECMP8
		echo "-----------SCENARIO: 8flow_20servers_ECMP-----------"
		sudo mn -c
		sudo killall python
		sudo python 8flow_20servers_ECMP.py 
	done

	echo "--------------- Computing Average -----------"
	echo " "
	echo "--------------- Topology Jellyfish (20 servers) "
	echo "--------------- ECMP8 --------- 8_shortest path "	

	# read the file and show the second column after ':' from the first to the 14 character (all lines) and compute the average
	average8flowECMP=`cat average8flow-ECMP.dat | awk -F ":" '{soma+=substr($2, 1, 14)} END {media=soma/3} END {printf("%.2f",media)}'`

	average8flow8shortest=`cat average8flow-8shortest.dat | awk -F ":" '{soma+=substr($2, 1, 14)} END {media=soma/3} END {printf("%.2f",media)}'`
	
	echo "MPTCP 8 flow -- $average8flowECMP --------- $average8flow8shortest ---------"
	echo " "
	echo "*** Finished MPTCP Experimet ((; ***"
}


# Print usage instructions
ShowUsage()
{
    echo -e "${GRAY}\n"
    echo "Script to run Jellyfish Topology"
    echo "Usage: sudo ./run.sh <COMMAND>"
    echo "Commands:"
    echo "   -t|--tcp                     Run TCP simulation"
    echo "   -m|--mptcp                   Run MPTCP simulation"
    echo "Examples:"
    echo "    sudo ./run.sh -t"
    echo "    sudo ./run.sh -m"
    echo -e "${WHITE}\n"
}


main()
{
  # $1 parametro 1 , $2 parametro 2 ...

    case "$1" in
        '-t'|'--tcp' )
            TCPExperiment 
        ;;

        '-m'|'--mptcp' )
            MPTCPExperiment 
        ;;

        *)
            ShowUsage
            exit 1
        ;;
    esac

    exit 0
}

main "$@"



