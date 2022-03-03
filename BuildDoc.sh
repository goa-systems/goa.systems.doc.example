#!/bin/bash

# Validate that tools are available in the global path ($env:PATH, %PATH%, ...)
mkdocs --help> /dev/null 2>&1
if [ "$?" -ne "0" ]; then echo "Can not find mkdocs."; exit; fi
pandoc --help> /dev/null 2>&1
if [ "$?" -ne "0" ]; then echo "Can not find pandoc."; exit; fi

if [ -d "out" ]
then
	echo "Output directory [out] exists. Cleaning up."
	rm -rf "out"
	echo "Existing output directory deleted."
fi

# Create output directories
echo "Creating directories"
mkdir -p "out/pdf"
mkdir -p "out/html"
echo "Directories created"

# Generate outputs
cd "docs"
pandoc "README.md" \
	../metadata.yml \
	--data-dir=/usr/local/share/pandoc \
	--metadata date=$(date +"%Y-%m-%d") \
	--metadata titlepage-background="../background.pdf" \
	--metadata logo=logo.png \
	-o "../out/pdf/example.pdf" \
	-f markdown \
	--template eisvogel.latex \
	--listing

cd ".."
mkdocs build -d "out/html"