#!/bin/bash
#
# @(#)$Id$
#
#
# Scan direcories for viruses
#
# ************************
# *To run with Anacron*
# or to add to /etc/cron.*
# -- cron.daily
# -- cron.weekly
# -- cron.monthly
# this file cannot end with .sh or runparts will not run it.
# For this, you will also need to make the file executable and owned by root
# chmod +x ClamAVCron && chown root:root ClamAVCron
# ************************
#
# ************************
# *To run with Cron or Anacron*
# You may want to replace the $USER to your preferred username
# eg. $USER=username
USER=$USER
# ************************


logdate=$(date "+%b-%d-%Y")
scandir="/home/$USER/"
logfile="${scandir}.clamtk/history/${logdate}.log"
ignoredir="${scandir}.local/share/Trash/"

# notif - Start Scan
#zenity --notification --text="ClamAV scan has been started"

clamscan -ir -l $logfile --exclude-dir=$ignoredir $scandir &> /dev/null

chown $USER:$USER $logfile

# notif - Scan Finished
#zenity --notification --text="ClamAV scan has finished"
