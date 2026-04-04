#!/bin/bash

API_KEY="Your_API"
CITY="Jakarta"
CACHE="$HOME/.cache/eww_weather"

mkdir -p "$(dirname "$CACHE")"

curl -s "https://api.weatherapi.com/v1/forecast.json?key=$API_KEY&q=$CITY&days=3&aqi=no&alerts=no" | jq -r '
def icon(cond):
  if cond | test("rain"; "i") then ""
  elif cond | test("cloud"; "i") then ""
  elif cond | test("sun|clear"; "i") then ""
  elif cond | test("storm|thunder"; "i") then ""
  else ""
  end;

.forecast.forecastday[] |
(.date | strptime("%Y-%m-%d") | strftime("%d %b")) + "|" +
icon(.day.condition.text) + "|" +
"\(.day.maxtemp_c)/\(.day.mintemp_c)°C" + "|" +
"\(.day.avghumidity)%"
' > "$CACHE"
