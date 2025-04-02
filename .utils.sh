#!/bin/bash

function show_containers {
	local ps=$(docker ps --no-trunc --format "{{.ID}}|{{.Image}}|{{.Command}}|{{.CreatedAt}}|{{.Status}}|{{.Ports}}|{{.Names}}")
	local i=1
	local line=$(echo "$ps" | sed "$i""q;d")

	local id=""
	local image=""
	local command=""
	local created=""
	local status=""
	local ports=""
	local name=""

	while [ ! -z "$line" ]
	do
		id=$(echo $line | awk -F '|' '{print $1}')
		image=$(echo $line | awk -F '|' '{print $2}')
		command=$(echo $line | awk -F '|' '{print $3}')
		created=$(echo $line | awk -F '|' '{print $4}' | awk '{print $2}')
		status=$(echo $line | awk -F '|' '{print $5}')
		ports=$(echo $line | awk -F '|' '{print $6}')
		name=$(echo $line | awk -F '|' '{print $7}')

		if [ -z "$ports" ]; then
			ports="N/A"
		fi
		
		echo -e "    " "-" "Image:  "  "$image"
		echo -e "    " "-" "Command:" "$command"
		echo -e "    " "-" "Created:" "$created" 
		echo -e "    " "-" "Status: "  "$status"
		echo -e "    " "-" "Ports:  "  "$ports"

		i=$(expr "$i" "+" "1")
		line=$(echo "$ps" | sed "$i""q;d")
	done
}

function show_volumes {
	local all_volumes=$(docker volume ls)
	local i=2
	local line=$(echo "$all_volumes" | sed "$i""q;d")
	local name=""

	while [ ! -z "$line" ]
	do
		echo -n "$line" | awk '{printf $2}'
		echo -ne " > "
		echo -ne "$line" | awk '{printf $1}'
		echo -n " driver"
		echo -ne " mounted at"" "
		name="$(echo "$line" | awk '{printf $2}')"
		echo -n $(docker volume inspect "$name" --format '{{json .Options.device}}')
		i=$(expr "$i" "+" "1")
		line=$(echo "$all_volumes" | sed "$i""q;d")
	done
}	

function show_networks {
	local all_networks=$(docker network ls)
	local i=2
	local line=$(echo "$all_networks" | sed "$i""q;d")

	local id=""
	local name=""
	local driver=""
	local scope=""

	while [ ! -z "$line" ]
	do
		id=$(echo $line | awk '{print $1}')
		name=$(echo $line | awk '{print $2}')
		driver=$(echo $line | awk '{print $3}')
		scope=$(echo $line | awk '{print $4}')

		echo -e  "$name" ":" "$id"
		echo -e "    " "-" "Driver:  " "$driver"
		echo -e "    " "-" "Scope :  " "$scope"

		i=$(expr "$i" "+" "1")
		line=$(echo "$all_networks" | sed "$i""q;d")
	done
}

if [ "$1" == "containers" ]; then
	show_containers
fi

if [ "$1" == "volumes" ]; then
	show_volumes
fi

if [ "$1" == "networks" ]; then
	show_networks
fi