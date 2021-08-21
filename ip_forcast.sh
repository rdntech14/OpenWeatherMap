#!/bin/bash
verify_ipaddress() {
    local ipaddress=$1
    local
    status=1
    if [[ $ipaddress =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        iparr=($ipaddress)
        [[ ${iparr[0]} -le 255 && ${iparr[1]} -le 255 && ${iparr[2]} -le 255 && ${iparr[3]} -le 255 ]]
        status=$?
    fi
}

getLatLonForIP() {
    read latlon location < <(echo $(curl -s "ipinfo.io/${ip}" | jq -r '.loc, .city'))
    IFS=','
    read -a strarr <<<"$latlon"
    # echo "lat : ${strarr[0]}, lon : ${strarr[1]} and location : ${location}"
}

getNextThreeDaysWeather() {

    result=$(curl -k "https://api.openweathermap.org/data/2.5/onecall?lat=${strarr[0]}&lon=${strarr[1]}&appid=a95ce5898d5ed605589d10056a233619" >result.json)

    echo $'\n-----------------------------------------------------------------------------\n'

    echo "Weather forecast for ${ip} (${location}):"$'\n'

    for i in 1 2 3; do
        # date=$(date -r $(jq -r ".daily[$i] | .dt" result.json) +%Y-%m-%d)  # on local machine Mac
        date=$(date -d @$(jq -r ".daily[$i] | .dt" result.json) +%Y-%m-%d) # on Debian docker image
        weather_description=$(jq -r ".daily[$i] | .weather[0].description" result.json)
        echo "$date:" $'\t' "$weather_description" "throughout the day."
    done
    echo $'\n-----------------------------------------------------------------------------'
}

echo "-----------------------------------------------------------------------------"
if [ ! -z $ip ] || [ ! -z $1 ]; then
    if [ ! -z $ip ]; then
        echo "ip passed from docker env variable ip"
    fi
    if [ ! -z $1 ]; then
        echo "ip passed to shell script from command line argument"
        ip=$1
    fi

else
    ip=$(dig @resolver4.opendns.com myip.opendns.com +short)
fi

verify_ipaddress $ip
unset IFS
if [ $status -ne 0 ]; then
    echo "ip address is invalid"
    exit
fi

echo "your pulic ip : ${ip}"

getLatLonForIP
getNextThreeDaysWeather
