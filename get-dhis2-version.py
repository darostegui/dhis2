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
