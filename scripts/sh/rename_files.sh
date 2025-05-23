#!/bin/bash
for filename in ./data/tmp/*; do
	mv "${filename}" "`echo ${filename} |sed 's/[[:space:]]*//g'`"
done
