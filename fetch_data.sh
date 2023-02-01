# bin/bash

rm -rf ./data
wget https://github.com/Hanslick-Online/hsl-transkribus-export/archive/refs/heads/main.zip
unzip main
mkdir ./data
mkdir ./data/editions
mkdir ./data/tmp
mkdir ./data/meta
touch ./data/meta/.gitkeep
mv hsl-transkribus-export-main/tei/162553/*.xml ./data/tmp
rm -rf hsl-transkribus-export-main
rm main.zip
