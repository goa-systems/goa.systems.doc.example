#!/bin/bash

if [ $(id -u) -ne 0 ]
then
	echo "This script must be run as root"
else

	# Install prerequisites
	apt install -y pandoc mkdocs texlive-latex-recommended texlive-latex-extra librsvg2-bin texlive-fonts-extra
	
	# Only download and install the template if it does not already exist
	if [ ! -f /usr/local/share/pandoc/templates/eisvogel.latex ]
	then
		wget -O /tmp/Eisvogel-2.0.0.tar.gz https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v2.0.0/Eisvogel-2.0.0.tar.gz
		mkdir /usr/local/share/pandoc/templates -p
		tar -C /usr/local/share/pandoc/templates -f /tmp/Eisvogel-2.0.0.tar.gz -x
	fi
fi
