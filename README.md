# ClamAV-cron-scan

This is a custom script that allows a user to scan their `~/home` folder using a popular AntiVirus software available for Linux - [ClamAV](https://www.clamav.net/).

View the [ClamAV Github page](https://www.clamav.net/).

Currently **UNSTABLE** -  please watch for releases if you are interested in this project.

## ClamAV Installation

Follow the recommended installation steps for your distro on their [documentation](https://www.clamav.net/documents/installing-clamav) page.

For an interactive gui, also install their *clamtk* package.

### Debian
`# apt install clamav clamtk anacron` <clamav-daemon uses too much RAM>

## How to install this script

### Using Anacron (preferred method)

<!-- language-all: bash -->

1. Make sure this script is executable

       $ chmod u+x ClamAVCron.sh

2. To allow Anacron to execute the file, link it in /usr/local/bin (see `run-parts`), or remove the .sh extension  
This will also allow you to scan directly from your terminal

       # ln -s /path/to/ClamAVCron.sh /usr/local/bin/clamscan-cron

3. Create a `.anacron` folder in your home directory and in it two subfolders, `etc` and `spool`:

       $ mkdir -p ~/.anacron/{etc,spool}

4. Create a new file `~/.anacron/etc/anacrontab` with contents similar to the following, insert your username in place of `<username>`:

        # /etc/anacrontab: configuration file for anacron

        # See anacron(8) and anacrontab(5) for details.

        SHELL=/bin/bash
        PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

        # period:         Delay in days
        # delay:          Delay in minutes
        # job-identifier: Unique name for anacron
        # command:        Command to execute
        # period  delay  job-identifier  command
        1         10     clamav-scan     /path/to/ClamAVCron.sh <username>
        # OR
        1         10     clamav-scan     /usr/local/bin/clamscan-cron <username>

5. Add the following line to your crontab using `crontab -e`:

        @hourly /usr/sbin/anacron -s -t $HOME/.anacron/etc/anacrontab -S $HOME/.anacron/spool

## Planned features
* Catch errors, such as *clamav* not installed
* Command line arguments for more flexibility
* Multiple distro support - if necessary
* Show a progress notification? [Sounds like a hack](https://serverfault.com/q/759972) that won't be efficient. Maybe just change final notification to a summary.
