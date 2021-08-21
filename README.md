# OpenWeatherMap

# To know next 3 days weather based on IP addesss

## Run docker without ip address
```
docker build . -t openweathermap
docker run openweathermap

```

## Run docker with ip address
```
docker build . -t openweathermap
docker run -e ip=1.1.1.1 openweathermap

```

## Run shell script inside docker without ip address
```
docker build . -t openweathermap
docker run -it --entrypoint=/bin/bash openweathermap
./ip_forcast.sh
```

## Run shell script inside docker with ip address
```
docker build . -t openweathermap
docker run -it --entrypoint=/bin/bash openweathermap
./ip_forcast.sh 1.1.1.1
```

## Run script on Mac machine locally
To execute ip_forcast.sh locally on Mac Machine, uncomment line # 32 and comment line # 33, like

```
date=$(date -r $(jq -r ".daily[$i] | .dt" result.json) +%Y-%m-%d)  # on local machine Mac
#date=$(date -d @$(jq -r ".daily[$i] | .dt" result.json) +%Y-%m-%d) # on Debian docker image

```
 then execute
 ```
 ./ip_forcast.sh
./ip_forcast.sh 1.1.1.1
 ```
