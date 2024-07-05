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
