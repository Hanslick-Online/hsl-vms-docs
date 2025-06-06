#!/usr/bin/env python
import os
import re

# Directory containing your image files
directory = "./data/facs"

# Regex pattern to match filenames
pattern = re.compile(r"^(Hanslick) (.*) (\d+\S*)$")
for filename in os.listdir(directory):
    if filename.endswith(".jpg"):
        new_filename = re.sub(pattern, r"\1_\2_\3", filename)
        new_filename = re.sub("^(\d*)\s*", r"d_\1_", new_filename)
        new_filename = new_filename.replace(' ', '')
        # Full file paths
        old_path = os.path.join(directory, filename)
        new_path = os.path.join(directory, new_filename)

        os.rename(old_path, new_path)
        print(f"{filename} -> {new_path}")
