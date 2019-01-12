# ClamAV-cron-scan

This is a custom script that allows a user to scan their `~/home` folder using a popular AntiVirus software available for Linux - [ClamAV](https://www.clamav.net/).

View the [ClamAV Github page](https://www.clamav.net/).

## ClamAV Installation

Follow the recommended installation steps for your distro on their [documentation](https://www.clamav.net/documents/installing-clamav) page.

For an interactive gui, also install their *clamtk* package.

### Debian
`# apt install clamav clamtk`

## How to install this script

### Using Anacron (preferred method)
[Credit to askubuntu answer](https://askubuntu.com/a/235090/611842)
<!-- language-all: bash -->

You can set up a separate anacron instance to run in user mode:

1. Create a `.anacron` folder in your home directory and in it two subfolders, `etc` and `spool`:

       mkdir -p ~/.anacron/{etc,spool}

2. Create a new file `~/.anacron/etc/anacrontab` with contents similar to the following:

        # /etc/anacrontab: configuration file for anacron

        # See anacron(8) and anacrontab(5) for details.

        SHELL=/bin/bash
        PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

        # period  delay  job-identifier  command
        1         10     clamav-scan     ClamAVCron.sh

3. Add the following line to your crontab using `crontab -e`:

        @hourly /usr/sbin/anacron -s -t $HOME/.anacron/etc/anacrontab -S $HOME/.anacron/spool

## Planned features
* Catch errors, such as *clamav* not installed
* Command line arguments for more flexibility
* Multiple distro support - if necessary
* Show a progress notification? [Sounds like a hack](https://serverfault.com/q/759972) that won't be efficient. Maybe just change final notification to a summary.
* If laptop, only run when plugged in?
