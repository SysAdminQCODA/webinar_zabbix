#!/bin/bash

c=$1
comando=$(docker ps --no-trunc --filter name=$c | sed -n '1!p' | awk -F"\"" '{print $2}')

ps aux | grep -w "$comando" -q && echo 1 || echo 0
