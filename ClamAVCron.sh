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
# 2. Create a `.anacron` folder in your home directory and in it two subfolders, `etc` and `spool`:
#
#     $ mkdir -p ~/.anacron/{etc,spool}
#
# 3. Create a new file `~/.anacron/etc/anacrontab` with contents similar to the following:
#
#         # /etc/anacrontab: configuration file for anacron
#
#         # See anacron(8) and anacrontab(5) for details.
#
#         SHELL=/bin/bash
#         PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
#
#         # period  delay  job-identifier  command
#         1         10     clamav-scan     ClamAVCron.sh
#
# 4. By using:
#
#      $ crontab -e
#
#   Add the following line:
#
#      @hourly /usr/sbin/anacron -s -t $HOME/.anacron/etc/anacrontab -S $HOME/.anacron/spool
#
# ****************************************************************************************************

USER=$USER

logdate=$(date "+%b-%d-%Y")
scandir="/home/$USER/"
logfile="$scandir.clamtk/history/$logdate.log"
ignoredir="$scandir.local/share/Trash/"

# notif - Start Scan
zenity --notification --text="ClamAV scan has been started"

clamscan -ir -l $logfile --exclude-dir=$ignoredir $scandir &> /dev/null

# notif - Scan Finished
zenity --notification --text="ClamAV scan has finished"
