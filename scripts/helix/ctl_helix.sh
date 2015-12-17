#!/bin/bash
# ctl_helix.sh - version 1.0
#
# Bash script to stop, start and check RDPS Module.
#
# Notes:
# - This script requires env_rdps.sh to be on the same folder, 
# this file is used to set all the environment variables.
#
# Change logs:
#	1.0: (hicham medkouri), intial version.

source env_helix.sh

clusters()
{
	. conf/${2}.properties
	${HELIX_HOME}/bin/helix-admin.sh --zkSvr ${zkAddress}${zkPath} --listClusters
}

cluster()
{
	. conf/${2}.properties
	${HELIX_HOME}/bin/helix-admin.sh --zkSvr ${zkAddress}${zkPath} --listClusterInfo ${3}
}

instances()
{
	. conf/${2}.properties
	${HELIX_HOME}/bin/helix-admin.sh --zkSvr ${zkAddress}${zkPath} --listInstances ${3}
}

instance()
{
	. conf/${2}.properties
	${HELIX_HOME}/bin/helix-admin.sh --zkSvr ${zkAddress}${zkPath} --listInstanceInfo ${3} ${4}
}

resources()
{
	. conf/${2}.properties
	${HELIX_HOME}/bin/helix-admin.sh --zkSvr ${zkAddress}${zkPath} --listResources ${3}
}

resource()
{
	. conf/${2}.properties
	${HELIX_HOME}/bin/helix-admin.sh --zkSvr ${zkAddress}${zkPath} --listResourceInfo ${3} ${4}
}

case "$1" in    
    clusters)        
		clusters $@
		;;
	cluster)        
		cluster $@
		;;
	instances)        
		instances $@
		;;
	instance)        
		instance $@
		;;
	resources)        
		resources $@
		;;
	resource)        
		resource $@
		;;
    *)
        echo "Usage: $0 {"
		echo "				clusters {env}									|"
		echo "				cluster {env} {clusterName} 					|"
		echo "				instances {env} {clusterName} 					|"
		echo "				instance {env} {clusterName} {instanceName} 	|"
		echo "				resources {env} {clusterName} 					|"
		echo "				resource {env} {clusterName} {resourceName} 	|"
		echo "			}"
		echo "where env = {local|dev|intg|prod}"
        exit 1
        ;;
esac
