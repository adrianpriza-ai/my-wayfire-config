#!/bin/bash

dir="$HOME/.config/rofi-me/launcher/"
theme='style-1'
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
