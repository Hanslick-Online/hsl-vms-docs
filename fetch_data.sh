# bin/bash

rm -rf ./data/editions
rm -rf ./data/facs
rm -rf ./data/tmp
rm -rf ./data/meta
wget https://github.com/Hanslick-Online/hsl-transkribus-export/archive/refs/heads/main.zip
unzip main
mkdir ./data/editions
touch ./data/editions/.gitkeep
mkdir ./data/tmp
mkdir ./data/facs
touch ./data/facs/.gitkeep
mkdir ./data/meta
touch ./data/meta/.gitkeep
mv hsl-transkribus-export-main/tei/162553/*.xml ./data/editions
mv hsl-transkribus-export-main/mets/162553/*.xml ./data/facs
rm -rf hsl-transkribus-export-main
rm main.zip
