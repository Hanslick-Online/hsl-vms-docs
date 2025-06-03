# bin/bash

# make nested directory in the root upload (images) directory 
# curl --anyauth --user $IIIF_CRED -k -X MKCOL 'https://iiif.acdh.oeaw.ac.at/upload/hsl-doc' 

# add local dir with images for upload
cd ./data/facs && find . -exec curl -T {} 'https://iiif.acdh.oeaw.ac.at/upload/hsl-doc/{}' --user $IIIF_CRED -k \;

# delete images
# curl --anyauth --user $IIIF_CRED -X "DELETE" "https://iiif.acdh.oeaw.ac.at/upload/hsl-doc/"
