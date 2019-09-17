[![CircleCI](https://circleci.com/gh/DallasO/ClamAV-cron-scan.svg?style=svg)](https://circleci.com/gh/DallasO/ClamAV-cron-scan)
# ClamAV-cron-scan

This is a custom script that allows a user to scan their `~/home` folder using a popular AntiVirus software available for Linux - [ClamAV](https://www.clamav.net/).

View the [ClamAV Github page](https://www.clamav.net/).

## ClamAV Installation

Follow the recommended installation steps for your distro on their [documentation](https://www.clamav.net/documents/installing-clamav) page.

For an interactive gui, also install their *clamtk* package.  
E.g. Debian: `$ sudo apt install clamav clamtk`

## How to use this script

### Set an hourly cron

<!-- language-all: bash -->

1. Make sure this script is executable

       $ chmod u+x ClamAVCron.sh

2. If you would like to invoke this script at any time from the terminal, or share with other users,  
link it in /usr/local/bin (see `run-parts`)

       # ln -s /path/to/ClamAVCron.sh /usr/local/bin/clamscan-cron

3. Add the following line to your crontab using `crontab -e`:  
Replace `[period]` with number of days between scans. default: 7

       @hourly /usr/local/bin/clamscan-cron user [period] >/dev/null 2>&1

## Planned features
* Should use tmp file for logfile until scan complete
* Change to sh for more portability
* Eventually fix notifications :/
* Command line arguments for more flexibility
* Multiple distro support - if necessary
* Show a progress notification? [Sounds like a hack](https://serverfault.com/q/759972) that won't be efficient. Maybe just change final notification to a summary.
