#!/bin/bash
# Feature extraction
awk -f featex.awk birds2024ext.csv > birdstrans.txt
echo "Feature extraction complete, check birdstrans.txt"


# Convert bird data to numerical codes
# ./namescodes -n birdstrans.txt -tbirdtable.txt -L

# Run Kingfisher algorithm on the transaction data
# ./kingfisher -i birdstrans.txt.codes -k170 -M-5 -q300 -o birdrules.txt

# Convert numerical codes in rules back to names
# ./namescodes -c birdrules.txt -tbirdtable.txt

