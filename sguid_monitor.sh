# This script monitors SUID/SGID files and compares the output with previous results
# By VirtualSamurai

#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# The SUID/SGID files list
file="sguid_monitor_list.txt"

# Check if colordiff is installed, if not it will install it.
colordiff_check()
{
    # Check if the script is run as root
    if [ "$EUID" -ne 0 ]
      then echo "Please run as root"
      exit
    fi

    if [ -x "$(command -v colordiff)" ]; then
        echo -e "${GREEN}colordiff is installed !"
        echo -e "${NC} "
    else
        echo -e "${RED}colordiff is not installed...Downloading"
        echo -e "${NC} "
        sudo apt install colordiff
    fi
}


# --------------------------
# Header function
header()
{
    echo " "
    echo " "
    echo "   _____   _____  _    _  _____  _____           __  __   ____   _   _ "
    echo "  / ____| / ____|| |  | ||_   _||  __ \         |  \/  | / __ \ | \ | |"
    echo " | (___  | |  __ | |  | |  | |  | |  | | ______ | \  / || |  | ||  \| |"
    echo "  \___ \ | | |_ || |  | |  | |  | |  | ||______|| |\/| || |  | || . ' |"
    echo "  ____) || |__| || |__| | _| |_ | |__| |        | |  | || |__| || |\  |"
    echo " |_____/  \_____| \____/ |_____||_____/         |_|  |_| \____/ |_| \_|"
    echo "                                                                       "
    echo "                                                                       "
    echo " "
}

# ---------------------------
# Footer function
footer()
{
    echo " "
    echo " "
    echo "################################"
    echo "#            v.0.1             #"
    echo "################################"
    echo " "
    echo " "
}

# ----------------------------
# Fetch previous list function


# -----------------------------
# Enumerating SUID and SGID files
enumerate()
{

    echo "Fetching previous list..."
    echo " "

    if [ -e "$file" ]
    then
        sleep 1
        echo "A previous list has been found ! Let's check if there are any changements"
        sleep 1
        echo " "
        echo "############################"
        echo "# Monitoring SGUID files : #"
        echo "############################"
        echo " "
        echo "Differences between the previous list and the new output"
        echo -e "${RED}Red : ${NC}Previous list"
        echo -e "${GREEN}Green : ${NC}New list"
        echo " "
        find / -perm /6000 -type f -exec ls -l {} 2>/dev/null \; | colordiff -u $file -
        echo " "
    else
        sleep 2
        echo "Writing results to $file"
        echo " "
        echo " "
        echo "############################"
        echo "# Enumerating SGUID files: #"
        echo "############################"
        echo " "
        find / -perm /6000 -type f -exec ls -l {} > $file 2>/dev/null \;
        cat $file
        echo " "
    fi

}


# ---------------------------
# Start function
start()
{
    colordiff_check
    header
    enumerate
    footer
}

start
