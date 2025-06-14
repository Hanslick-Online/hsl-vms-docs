#!/bin/bash

# Directory containing your image files
#!/bin/bash

# Safely extract .jpg or .jpeg URLs
grep -E 'jpe?g' data/tmp/* | sed -n 's/.*url="\([^"]*jpe\?g\)".*/\1/p' | while IFS= read -r file_name; do

    # Normalize filename: .jpeg → .jpg, replace spaces, reformat
    new_name=$(echo "$file_name" | \
        sed 's/.jpeg$/.jpg/' | \
	sed -E 's/^Hanslick (.+) ([0-9]+-[0-9]+\.jpg)$/Hanslick_\1_\2/' | sed -E 's/^([0-9]*) */d_\1_/' | tr -d ' ')
    sed -i "s|$file_name|$new_name|g" data/tmp/*xml
done

for xmlfile in data/editions/*.xml; do
	./scripts/py/join_p.py "$xmlfile"
done
#sed -i -E 's/(Hanslick_.+\.jpg)/d__\1/g' data/editions/*
