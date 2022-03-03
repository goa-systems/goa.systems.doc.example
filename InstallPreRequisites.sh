#!/bin/bash

apt install -y pandoc mkdocs pdflatex pandoc mkdocs pandoc mkdocs git -y texlive-latex-recommended texlive-latex-extra librsvg2-bin texlive-fonts-extra

wget -O /tmp/Eisvogel-2.0.0.tar.gz https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v2.0.0/Eisvogel-2.0.0.tar.gz
mkdir ~/.pandoc/templates -p
tar -C ~/.pandoc/templates -f /tmp/Eisvogel-2.0.0.tar.gz -x