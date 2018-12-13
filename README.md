# ClamAV-cron-scan

This is a custom script that allows a user to scan their `~/home` folder using a popular AntiVirus software available for Linux - [ClamAV](https://www.clamav.net/).

View the [ClamAV Github page](https://www.clamav.net/).

## Installation

Follow the recommended installation steps for your distro on their [documentation](https://www.clamav.net/documents/installing-clamav) page.

For an interactive gui, also install their *clamtk* package.

### Debian
`# apt install clamav clamtk`

## Planned features
* Catch errors, such as *clamav* not installed
* Command line arguments for more flexibility
* Integrate with notification provider, or rather **fix** the integration
* Multiple distro support - if necessary
