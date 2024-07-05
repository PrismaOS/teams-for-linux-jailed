[![Please don't upload to GitHub](https://nogithub.codeberg.page/badge.svg)](https://nogithub.codeberg.page)

# teams-for-linux-jailed.sh
Script:  teams-for-linux-jailed.sh
Version: 2024-07-05 14:15 UTC
Purpose: a script to load teams-for-linux in a firejail, or alternatively provide a meeting link to load in an already open / active t4l window

# Supported parameters
```shell
#  --url      if the parameter --url is explicitly provided, the next parameter on the
#             command line will be force-interpreted as a meeting link (and fail, if
#             it's not a valid pattern match)
#  <link>     any parameter starting with https://teams.microsoft.com/l (TEAMS_LINK_PATTERN)
#             will be interpreted as the meeting link & converted to a msteams://l* address
#  bash       this parameter opens a bash instead of teams, so that you can check what
#             jail environment the process will see
#  --dry-run  suppresses command execution, so that all you see is the final echo of the
#             command that would be executed
#  --help     (or -h, ?, help) display this script documentation
# 
# NOTE: I am using the FIREFOX variable to mimic my firejail settings from firefox as I
#  use it for webex,
#        - setting --noprofile which fixed camera & microphone access for me
#            and
#        - clearing the environment variable DBUS_SESSION_BUS_ADDRESS because it annoys
#          the hell out of me that despite an application being in a jail, it appears to
#          the user as if it has access to my home folder.
```

# Global variables
```shell
# DEBUG - if set to "yes", will output some variable status along the way
# EXECUTE - if set to "no", has the same effect as --dry-run, but permanently (until changed back to "yes")
DEBUG="no" # set to yes for debugging output
EXECUTE="yes"  # set to yes if final command shall be executed, no if not. Parameter --dry-run sets this to "no"

# Configure your firejail path for teams-for-linux here:
TEAMS4L_JAIL_PATH="~/jails/teams-for-linux"

# The pattern that will be replaced with msteams:/l in a meeting link
TEAMS_LINK_PATTERN="https\:\/\/teams\.microsoft\.com\/l"
```
