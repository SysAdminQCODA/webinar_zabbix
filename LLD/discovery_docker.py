#!/usr/bin/env python

from json import dumps
import subprocess

p = subprocess.Popen('docker ps | sed -n \'1!p\'', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
#for line in p.stdout.readlines():
#    names = line.split()[-1],
retval = p.wait()

names = [x.split()[-1] for x in p.stdout.readlines()]

#with open('containers.txt') as f:
#    content = f.readlines()
#names = [x.split()[-1] for x in content]

#data = json.dumps({ 'data': [ {'{#CNAME}': name} for name in names ] })

print(names)
