#!/bin/bash
#
# @(#)$Id$
#
#
# Scan direcories for viruses
#
# ****************************************************************************************************
# The preferred method of using this script is with a separate anacron instance running in user mode
#
# ****************************************************************************************************
#
# 1. Make sure this script is executable
#     $ chmod u+x ClamAVCron.sh
#
# 2. To allow Anacron to execute the file, symlink it in /usr/local/bin (see run-parts), or remove the .sh extension
#    This will also allow you to scan directly from your terminal
#     # ln -s /path/to/ClamAVCron.sh /usr/local/bin/clamscan-cron
#
# 3. Create a `.anacron` folder in your home directory and in it two subfolders, `etc` and `spool`:
#
#     $ mkdir -p ~/.anacron/{etc,spool}
#
# 4. Create a new file `~/.anacron/etc/anacrontab` with contents similar to the following, insert your username in place of `<username>`:
#
#         # /etc/anacrontab: configuration file for anacron
#
#         # See anacron(8) and anacrontab(5) for details.
#
#         SHELL=/bin/bash
#         PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
#
#         # period:         Delay in days
#         # delay:          Delay in minutes
#         # job-identifier: Unique name for anacron
#         # command:        Command to execute
#         # period  delay  job-identifier  command
#         1         10     clamav-scan     /path/to/ClamAVCron <username>
#         # OR
#         1         10     clamav-scan     /usr/local/bin/clamscan-cron <username>
#
# 5. By using:
#
#      $ crontab -e
#
#   Add the following line:
#
#      @hourly /usr/sbin/anacron -s -t $HOME/.anacron/etc/anacrontab -S $HOME/.anacron/spool
#
# ****************************************************************************************************
set -u

# USER=$USER

# Make sure ClamAV is installed
# if [[ '/usr/bin/clamscan -V' ]]; then
#   /bin/echo "ClamAV not found."
#   /bin/echo "https://www.clamav.net/documents/installing-clamav"
#   exit 1
# fi

if /usr/bin/id -u $1 > /dev/null 2>&1; then
  USER=$1
else
  /bin/echo "Valid user required. Please use '$0 user'."
  if [ $1 != 'test' ]; then
    exit 1
  fi
fi

if hash /usr/bin/on_ac_power 2>/dev/null; then
  # Assume always on AC if on_ac_power doesn't exist
  onAC=0
else
  onAC=$(/usr/bin/on_ac_power; echo $?;)
fi

if [ $onAC -ne 0 ]; then
  /bin/echo "Not on AC Power. Skipping."
  exit 1
fi

# notif - Start Scan
# /usr/bin/env SCREEN=:0 DISPLAY=:0 /usr/bin/zenity --notification --text="ClamAV scan has been started"
# notify-send 'Hello world!' 'ClamAV scan has been started.' --icon=dialog-information


if [ $1 != 'test' ]; then

  logdate=$(date "+%b-%d-%Y")
  scandir="/home/$USER/"
  logfolder="$scandir.clamtk/history/"
  mkdir -p $logfolder
  logfile="$logfolder$logdate.log"
  ignoredir="$scandir.local/share/Trash/"

  /usr/bin/clamscan -ir --log=$logfile --exclude-dir=$ignoredir $scandir &> /dev/null
  # /bin/echo  "SCANNING"
fi

# notif - Scan Finished
# /usr/bin/env SCREEN=:0 DISPLAY=:0 /usr/bin/zenity --notification --text="ClamAV scan has finished"
# notify-send 'Hello world!' 'ClamAV scan has finished.' --icon=dialog-information
