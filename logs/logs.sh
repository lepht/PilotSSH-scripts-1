#!/bin/bash

if [ "$#" -ne 1 ]
then
  path="/var/log"
else
  path=$1
fi

IFS=$'\n'$'\r'
files=( $(find $path -maxdepth 1 -type f -not -name "*.gz" | sort) )
dirs=( $(find $path -maxdepth 1 -type d | sort) )

#remove the current directory from the list
unset dirs[0]
result='{ "version": 1, "title": "Logs", "type":"commands", "values" : ['
result=$result"{\"name\":\"$path\", \"value\":\"\", \"command\":\"\"}"


for dir in "${dirs[@]}"; do
  result=$result", {\"name\":\"$dir\", \"value\":\"\", \"command\":\".pilotssh/logs/logs.sh $dir\"}"
done

for file in "${files[@]}"; do
  result=$result", {\"name\":\"$file\", \"value\":\"\", \"command\":\".pilotssh/logs/logs_show.sh $file\"}"
done

result=$result" ]}"
echo $result
