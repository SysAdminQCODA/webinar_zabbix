#!/bin/bash

token_rundeck="CBWVq9yLs7dP8PjzOzRMhu3ppfewXyme"
rundeck="http://rundeck-webinar.sysadminqcoda.com:4440"

api="api/14/project/Meetup01/run/command"
comando=$2
host=$1
curl -X "POST" -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Rundeck-Auth-Token:$token_rundeck" "$rundeck/$api" -d "{
\"project\": \"Meetup01\",
\"exec\": \"$comando\",
\"filter\": \"$host\"}"
