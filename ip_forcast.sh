#!/bin/bash

echo "****************"
if [ ! -z $ip ] || [ ! -z $1 ]; then
    echo "not empty"
    if [ ! -z $ip ]; then
        echo "ip assigned from DOCKER env variable"
    fi
    if [ ! -z $1 ]; then
        echo "ip assigned from shell command input"
        ip=$1
    fi

else
    echo "empty"
    # ip="$(ifconfig | grep -A 1 'services1:' | tail -1 | cut -d ' ' -f 2)" # on Ubuntu
    ip=$(ipconfig getifaddr en0) # on Mac
fi

# ip="12.165.188.173"
echo "ip : ${ip}"
echo "****************"

if [ -z $ip ]; then
    echo " no ip found"
    exit 1
fi

getLatLonForIP() {
    echo "in getLatLonForIP method and ip value is ${ip}"
    read latlon location < <(echo $(curl -s "ipinfo.io/${ip}" | jq -r '.loc, .city'))
    echo "latlon : ${latlon}"
    echo "location : ${location}"

    IFS=','
    read -a strarr <<<"$latlon"
    echo "lat : ${strarr[0]} "
    echo "lon : ${strarr[1]} "
}

getLatLonForIP

getnextThreeDaysWeather() {

    result=$(curl -k "https://api.openweathermap.org/data/2.5/onecall?lat=${strarr[0]}&lon=${strarr[1]}&appid=bf55d112094f7fc0490dbc70db1cb5a2" >result.json)

    echo "------------"

    echo "Weather forecast for ${ip} (${location}):"

    for i in 1 2 3; do
        # date=$(date -r $(jq -r  ".daily[$i] | .dt" result.json)  +%Y-%m-%d)
        date=$(date -d @$(jq -r ".daily[$i] | .dt" result.json) +%Y-%m-%d)
        weather_description=$(jq -r ".daily[$i] | .weather[0].description" result.json)
        echo $date: $weather_description "throughout the day."
    done

}

getnextThreeDaysWeather
