#!/bin/bash
if [[ -z $1 && -z $2 ]]; then
 echo "USAGE bash get-dhis2-version.sh http://localhost admin:district"
else
 API_VERSION=`curl -s $1/api/33/system/info -u "$2" | jq -r .version` ## Get it
 echo $API_VERSION ## Print it
 logger -p local0.notice -t ${0##*/}[$$] DHIS VERSION at `date +"%D %T"` :  $API_VERSION ## log it
fi

### Should return and log:
### ./get-dhis2-version.sh http://localhost admin:district
### 2.40.2
### tail -n 1 /var/log/syslog
### Dec 16 08:58:56 darostegui-backup -bash[1026859]: DHIS VERSION at 12/16/23 08:58:56 : 2.40.2
### syslog get logrotated on most systems
