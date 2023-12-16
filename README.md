# Docker dhis with nginx reverse proxy

Based on [dhis2-core](https://github.com/dhis2/dhis2-core/) but adding nginx reverse proxy on the override file Listening on the exposed port 80 the dhis2 tomcat running on port 8080.

## How to run it

### DHIS2 v2.40.2
```
 DHIS2_IMAGE=dhis2/core:2.40.2 DHIS2_DB_DUMP_URL=https://databases.dhis2.org/sierra-leone/2.40.2/dhis2-db-sierra-leone.sql.gz docker compose up
```

You can customize versions and datasource changing the parameters above

### Docker Containers:

Added nginx as [override](https://github.com/darostegui/dhis2/blob/main/docker-compose.override.yml) on the docker composer:

<img width="354" alt="image" src="https://github.com/darostegui/dhis2/assets/61184284/2ace6bab-790d-4c59-9711-0f35952f86ed">


I closed port 8080-8081 and 9010 as they were used for debug and direct access to dhis (instead of using nginx).

<img width="1337" alt="image" src="https://github.com/darostegui/dhis2/assets/61184284/2927f361-0558-4b04-9aac-d4503585ebf3">

### Screenshots

| <img width="500" alt="image" src="https://github.com/darostegui/dhis2/assets/61184284/852335b4-ea72-4852-93c6-4c14a12307eb"> | <img width="500" alt="image" src="https://github.com/darostegui/dhis2/assets/61184284/46828cf7-eafc-4999-88a7-6437b8836a72">| 
|---|---|
| <img width="500" alt="image" src="https://github.com/darostegui/dhis2/assets/61184284/78756598-708f-401e-b445-cdb394a9bb3b"> | <img width="500" alt="image" src="https://github.com/darostegui/dhis2/assets/61184284/b2ff0963-b6b7-4482-a592-7ce67ffdf81b"> |
| <img width="500" alt="image" src="https://github.com/darostegui/dhis2/assets/61184284/56dcd891-d833-4505-9cdc-f975390433a6">|  <img width="500" alt="image" src="https://github.com/darostegui/dhis2/assets/61184284/78c18a48-2149-4c91-9a85-1cc7b85602d9"> |
| <img width="500" alt="image" src="https://github.com/darostegui/dhis2/assets/61184284/e35f2b37-b014-4faf-8bbe-26000e43d437"> | <img width="500" alt="image" src="https://github.com/darostegui/dhis2/assets/61184284/d96e40f5-af71-40fe-854e-48ecebbce78a">|


### Dhis Version script

Result of testing both scripts: 

<img width="463" alt="image" src="https://github.com/darostegui/dhis2/assets/61184284/c5a1904f-cce2-4a61-a8ff-f47049233a31">

#### Bash

```
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
```

#### Python

```
import requests
import json
import sys, getopt
import syslog

hostname = sys.argv[1]
arg2 = sys.argv[2]
userpassword = arg2.split(":", 1)

from requests.auth import HTTPBasicAuth
res = requests.get(hostname +'/api/33/system/info', auth=HTTPBasicAuth(userpassword[0], userpassword[1]))
result = json.loads(res.content)
print(result['version'])
syslog.syslog('DHIS API '+result['version'])
```

