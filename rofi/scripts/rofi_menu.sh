#!/bin/bash
declare -a texts icons commands


ENTRIES=""
RESULT_FORMAT="s"
PROMPT="dmenu:"
ROFI_OPTIONS=(-dmenu -i)
THEME="$HOME/.config/rofi/themes/Adapta-Teal.rasi"
THEME_CHANGES=""



function buildEntries(){
    local entries="";
    local i=0;
    for i in ${!texts[@]}; do
        entries+="${texts[$i]}\0icon\x1f${icons[$i]}\n"
    done
    echo $entries
};



# $1 = a string of the entries which should be passed to rofi
function launchMenu(){
    echo $( echo -en $1 | rofi ${ROFI_OPTIONS[@]} -theme "$THEME" -theme-str "$THEME_CHANGES" -p "$PROMPT" -format $RESULT_FORMAT)
};



function launchMenuWithBuiltEntries(){
    ENTRIES=$(buildEntries)
    launchMenu "$ENTRIES"
};



# $1 = name of the file which should be read
function launchMenuFromFile(){
    echo $( rofi ${ROFI_OPTIONS[@]} -theme "$THEME" -theme-str "$THEME_CHANGES" -p "$PROMPT" -format $RESULT_FORMAT -input "$1")
};



# $1 = index of the command which should be executed
function evaluateCommand(){
    eval ${commands[$1]}
};
