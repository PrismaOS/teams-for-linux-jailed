#!/bin/sh
SCRIPT=teams-for-linux-jailed.sh
VERSION="2024-07-05 14:15 UTC"
PURPOSE="a script to load teams-for-linux in a firejail, or alternatively provide a meeting link to load in an already open / active t4l window"
PARAMS_01="# Supported parameters:"
PARAMS_02="#  --url      if the parameter --url is explicitly provided, the next parameter on the"
PARAMS_03="#             command line will be force-interpreted as a meeting link (and fail, if"
PARAMS_04="#             it's not a valid pattern match)"
PARAMS_05="#  <link>     any parameter starting with https://teams.microsoft.com/l (TEAMS_LINK_PATTERN)"
PARAMS_06="#             will be interpreted as the meeting link & converted to a msteams://l* address"
PARAMS_07="#  bash       this parameter opens a bash instead of teams, so that you can check what"
PARAMS_08="#             jail environment the process will see"
PARAMS_09="#  --dry-run  suppresses command execution, so that all you see is the final echo of the"
PARAMS_10="#             command that would be executed"
PARAMS_11="#  --help     (or -h, ?, help) display this script documentation"
PARAMS_12="# "
PARAMS_13="# NOTE: I am using the FIREFOX variable to mimic my firejail settings from firefox as I"
PARAMS_14="#  use it for webex,"
PARAMS_15="#        - setting --noprofile which fixed camera & microphone access for me"
PARAMS_16="#            and"
PARAMS_17="#        - clearing the environment variable DBUS_SESSION_BUS_ADDRESS because it annoys"
PARAMS_18="#          the hell out of me that despite an application being in a jail, it appears to"
PARAMS_19="#          the user as if it has access to my home folder."

# Global variables:
# DEBUG - if set to "yes", will output some variable status along the way
# EXECUTE - if set to "no", has the same effect as --dry-run, but permanently (until changed back to "yes")
DEBUG="no" # set to yes for debugging output
EXECUTE="yes"  # set to yes if final command shall be executed, no if not. Parameter --dry-run sets this to "no"

# Configure your firejail path for teams-for-linux here:
TEAMS4L_JAIL_PATH="~/jails/teams-for-linux"

# The pattern that will be replaced with msteams:/l in a meeting link
TEAMS_LINK_PATTERN="https\:\/\/teams\.microsoft\.com\/l"

COMMAND=teams-for-linux
FIREFOX="yes"
URL_OPTION=
GET_MEETING_LINK="no"
RAW_LINK=
MEETING_LINK=

echo "" # empty line at begin

number=1
for param in "$@"; do
    if [ "$DEBUG" = "yes" ]; then
        echo "param $number is $param, GET_MEETING_LINK is $GET_MEETING_LINK"
        number=`expr $number + 1`
    fi

    LINK_FOUND=`echo $param | sed "s/$TEAMS_LINK_PATTERN.*/LINK_FOUND/g"`
    # echo "vs. sed 's/$TEAMS_LINK_PATTERN.*/LINK_FOUND' is: $LINK_FOUND"
    if [ "$LINK_FOUND" = "LINK_FOUND" ]; then
        if [ "$DEBUG" = "yes" ]; then
            echo "found teams link!"
        fi
        URL_OPTION="--url" # force --url option so that meeting can be opened in existing teams instance
        GET_MEETING_LINK="yes"
    fi

    if [ "$GET_MEETING_LINK" = "yes" ]; then
        GET_MEETING_LINK="no"
        RAW_LINK=$param
        # MEETING_LINK=`echo $RAW_LINK | sed 's/https\:\/\/teams\.microsoft\.com\/l/msteams\:\/l/g'`
        MEETING_LINK=`echo $RAW_LINK | sed "s/$TEAMS_LINK_PATTERN/msteams\:\/l/g"`
    elif [ "$param" = "firefox" ]; then
        : # no-op, firefox is default
    elif [ "$param" = "bash" ]; then
        COMMAND=bash
    elif [ "$param" = "--url" ]; then
        URL_OPTION="--url"
        GET_MEETING_LINK="yes"
    elif [ "$param" = "--dry-run" ]; then
        echo "Performing a dry-run, command will not be executed!"
        EXECUTE="no"
    elif [ "$param" = "help" ] || [ "$param" = "?" ] || [ "$param" = "-h" ] || [ "$param" = "--help" ]; then
        HELP="yes"
    else
        PARAMS="$PARAMS \"$param\""
    fi
done

if [ "$HELP" = "yes" ]; then
    echo "Script:  $SCRIPT"
    echo "Version: $VERSION"
    echo "Purpose: $PURPOSE"
    echo ""
    echo "Usage:"
    echo "-------------------------------"
    echo "$PARAMS_01"
    echo "$PARAMS_02"
    echo "$PARAMS_03"
    echo "$PARAMS_04"
    echo "$PARAMS_05"
    echo "$PARAMS_06"
    echo "$PARAMS_07"
    echo "$PARAMS_08"
    echo "$PARAMS_09"
    echo "$PARAMS_10"
    echo "$PARAMS_11"
    echo "$PARAMS_12"
    echo "$PARAMS_13"
    echo "$PARAMS_14"
    echo "$PARAMS_15"
    echo "$PARAMS_16"
    echo "$PARAMS_17"
    echo "$PARAMS_18"
    echo "$PARAMS_19"
    exit 0
fi

DBUS=
PROFILE="--profile=/etc/firejail/teams-for-linux.profile"
if [ "$FIREFOX" = "yes" ]; then
    PROFILE="--noprofile"
    DBUS="env DBUS_SESSION_BUS_ADDRESS=none"
fi

if [ "$DEBUG" = "yes" ]; then
    echo "FIREFOX is $FIREFOX"
    echo "RAW_LINK is $RAW_LINK"
    echo "DBUS is $DBUS"
    echo "PROFILE is $PROFILE"
    echo "COMMAND is $COMMAND"
    echo "URL_OPTION is $URL_OPTION"
    echo "MEETING_LINK is $MEETING_LINK"
    echo "PARAMS is $PARAMS"
fi

echo "$DBUS firejail $PROFILE --private=$TEAMS4L_JAIL_PATH $COMMAND $URL_OPTION $MEETING_LINK $PARAMS"
if [ "$EXECUTE" = "yes" ]; then
    $DBUS firejail $PROFILE --private=$TEAMS4L_JAIL_PATH $COMMAND $URL_OPTION $MEETING_LINK $PARAMS
fi
