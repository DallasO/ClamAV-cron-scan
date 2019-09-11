#!/bin/bash
#
# @(#)$Id$
#
#
# Scan direcories for viruses
#
#******************************************************************************************
# You can set an hourly cron for a laptop, or weekly/monthly for servers
#******************************************************************************************
#
# 1. Make sure this script is executable
#     $ chmod u+x ClamAVCron.sh
#
# 2. If you would like to invoke this script at any time from the terminal,
#    link it in /usr/local/bin (see `run-parts`)
#
#     # ln -s /path/to/ClamAVCron.sh /usr/local/bin/clamscan-cron
#
# 3. Add the following line to your crontab using `crontab -e`:
#
#      @hourly /usr/sbin/anacron -s -t $HOME/.anacron/etc/anacrontab -S $HOME/.anacron/spool
#
#******************************************************************************************
set -o nounset ;
set -o errexit ;
set -o xtrace  ;

# Make sure ClamAV is installed
if ! type -p /usr/bin/clamscan &> /dev/null ; then
  /bin/echo "ClamAV not found." ;
  /bin/echo "https://www.clamav.net/documents/installing-clamav" ;
  exit 1 ;
fi

if /usr/bin/id -u "$1" > /dev/null 2>&1; then
  USER=$1 ;
else
  /bin/echo "Valid user required." ;
  /bin/echo "Please use EXAMPLE:" ;
  /bin/echo "\$ $0 $USER" ;
  if [ "$1" != 'test' ]; then
    exit 1 ;
  fi
fi

# How oten should we scan? default: 7 days
scriptdir="$(dirname "$(readlink -f "$0")")"
lockfile="$scriptdir/spool" ;
recur=${2-7} ;

if ( set -o noclobber; date "+%Y-%m-%d" > "$lockfile") 2> /dev/null; 
then
   trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT ;
else
  lastrun=$( cat "$lockfile" ) ;
  if (( ($(date +%s) - $(date --date="$lastrun" +%s) )/(60*60*24) > recur )); then
    date "+%Y-%m-%d" > "$lockfile" ;
  else
    echo "We don't have to run" ;
    exit 0 ;
  fi
fi

logdate=$(date "+%b-%d-%Y") ;
scandir="/home/$USER/" ;
logfolder="$scandir.clamtk/history/" ;
logfile="$logfolder$logdate.log" ;
ignoredir="$scandir.local/share/Trash/" ;

if [ "$1" != 'test' ]; then

  if ! type -p /usr/bin/on_ac_power &> /dev/null; then
    # Assume always on AC if on_ac_power doesn't exist
    onAC=0 ;
  else
    onAC=$(/usr/bin/on_ac_power && echo "0" || echo "1") ;
  fi

  if (( onAC != 0  )); then
    /bin/echo "Not on AC Power. Skipping." ;
    exit 1 ;
  fi

  # notif - Start Scan
  # /usr/bin/env SCREEN=:0 DISPLAY=:0 /usr/bin/zenity --notification --text="ClamAV scan has been started"
  # notify-send 'Hello world!' 'ClamAV scan has been started.' --icon=dialog-information

  mkdir -p "$logfolder" ;

  trap 'rm -f $lockfile; rm -f $logfile; exit' INT TERM EXIT ;

  /usr/bin/nice -n 10 /usr/bin/clamscan -ir --log="$logfile" --exclude-dir="$ignoredir" "$scandir" &> /dev/null ;
  # /bin/echo  "SCANNING"

  trap - INT TERM EXIT ;

else

  trap - INT TERM EXIT ;

  echo "logdate: $logdate"
  echo "scandir: $scandir"
  echo "logfolder: $logfolder"
  echo "logfile: $logfile"
  echo "ignoredir: $ignoredir"
  
fi

# notif - Scan Finished
# /usr/bin/env SCREEN=:0 DISPLAY=:0 /usr/bin/zenity --notification --text="ClamAV scan has finished"
# notify-send 'Hello world!' 'ClamAV scan has finished.' --icon=dialog-information
