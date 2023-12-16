#!/bin/bash
API_VERSION=`curl -s http://localhost/api/33/system/info -u "admin:district" | jq -r .version` ## Get it
echo $API_VERSION ## Print it
logger -p local0.notice -t ${0##*/}[$$] DHIS VERSION at `date +"%D %T"` :  $API_VERSION ## log it

### Should return and log:
### ./dhis-version.sh
### 2.40.2
### tail -n 1 /var/log/syslog
### Dec 16 08:58:56 darostegui-backup -bash[1026859]: DHIS VERSION at 12/16/23 08:58:56 : 2.40.2
### syslog get logrotated on most systems
