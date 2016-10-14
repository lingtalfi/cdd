#!/bin/bash



#----------------------------------------
# CONFIG
#----------------------------------------
configFile="${HOME}/.cdd_paths"



#----------------------------------------
# FUNCTIONS
#----------------------------------------
error (){
    echo "$1"
    exit 1
}



#----------------------------------------
# SCRIPT
#----------------------------------------

if [ ! -f "$configFile" ]; then
    touch "$configFile"
fi

RED="0;31m"
GREEN="0;33m"
PROGRAM_NAME="cdd"



# save current directory to bookmarks
function s {
	check_help $1
    _bookmark_name_valid "$@"
    if [ -z "$exit_message" ]; then
        _purge_line "$configFile" "export DIR_$1="
        CURDIR=$(echo $PWD| sed "s#^$HOME#\$HOME#g")
        echo "export DIR_$1=\"$CURDIR\"" >> $configFile
    fi
}

# jump to bookmark
function g {
    source $configFile
    target="$(eval $(echo echo $(echo \$DIR_$1)))"
    if [ -d "$target" ]; then
        cd "$target"
    elif [ ! -n "$target" ]; then
        echo -e "\033[${RED}WARNING: '${1}' bookmark does not exist\033[00m"
    else
        echo -e "\033[${RED}WARNING: '${target}' does not exist\033[00m"
    fi
}

# print bookmark
function p {
	check_help $1
    source $configFile
    echo "$(eval $(echo echo $(echo \$DIR_$1)))"
}

# open bookmark
function o {
    check_help $1
    source $configFile
    open "$(eval $(echo echo $(echo \$DIR_$1)))"
    g $1        
}

# delete bookmark
function d {
	check_help $1
    _bookmark_name_valid "$@"
    if [ -z "$exit_message" ]; then
        _purge_line "$configFile" "export DIR_$1="
        unset "DIR_$1"
    fi
}

# list bookmarks with dirnam
function l {
	check_help $1
    source $configFile
    # if color output is not working for you, comment out the line below '\033[1;32m' == "red"
    env | sort | awk '/^DIR_.+/{split(substr($0,5),parts,"="); printf("\033[0;33m%-20s\033[0m %s\n", parts[1], parts[2]);}'
    
    # uncomment this line if color output is not working with the line above
    # env | grep "^DIR_" | cut -c5- | sort |grep "^.*=" 
}




# print out help for the forgetful
function check_help {
    if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] ; then
        echo ''
        echo 's <bookmark_name> - Saves the current directory as "bookmark_name"'
        echo 'g <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"'
        echo 'p <bookmark_name> - Prints the directory associated with "bookmark_name"'
        echo 'd <bookmark_name> - Deletes the bookmark'
        echo 'l                 - Lists all available bookmarks'
        echo 'h  help'
        echo 'o  open'
        kill -SIGINT $$
    fi
}




# validate bookmark name
function _bookmark_name_valid {
    exit_message=""
    if [ -z $1 ]; then
        exit_message="${PROGRAM_NAME}: bookmark name required"
        echo $exit_message
    elif [ "$1" != "$(echo $1 | sed 's/[^A-Za-z0-9_]//g')" ]; then
        exit_message="${PROGRAM_NAME}: bookmark name is not valid"
        echo $exit_message
    fi
}



# safe delete line from configFile
function _purge_line {
    if [ -s "$1" ]; then
        # safely create a temp file
        t=$(mktemp -t cdd_bookmarks.XXXXXX) || exit 1
        trap "/bin/rm -f -- '$t'" EXIT

        # purge line
        sed "/$2/d" "$1" > "$t"
        /bin/mv "$t" "$1"

        # cleanup temp file
        /bin/rm -f -- "$t"
        trap - EXIT
    fi
}


