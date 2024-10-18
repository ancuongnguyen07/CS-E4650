#!/bin/bash
NOTEBOOK_PATH="./solution.ipynb"
PYTHON_SCRIPT_PATH="./solution.py"
KINGFISHER="./kingfisher/kingfisher"
NAMESCODE="./namecodes/namescodes"

RESULT_FILES_CONTAINER="./results"
TRANSBIRD_FILE="$RESULT_FILES_CONTAINER/transbird.csv"
NUMCODE_FILE="$RESULT_FILES_CONTAINER/birdtable.txt"
RULES_FILE="$RESULT_FILES_CONTAINER/birdrules.txt"
CONSTRAINTS_FILE="$RESULT_FILES_CONTAINER/birdconstraints.txt"

printf "\nConvert Jupyter Notebook to Python script....\n"
jupyter nbconvert --to python --output $PYTHON_SCRIPT_PATH $NOTEBOOK_PATH

if [[ ! -d $RESULTS_FILE_PREFIX ]]; then
    mkdir -p $RESULT_FILES_CONTAINER
fi

printf "\nRun the transaction-exploring Python script...\n"
python $PYTHON_SCRIPT_PATH $RESULT_FILES_CONTAINER

printf "\nConvert bird transactions to numerical codes...\n"
$NAMESCODE -n $TRANSBIRD_FILE -t $NUMCODE_FILE -L

# printf "Convert contransts (optional)"
#

printf "\nRun Kingfisher for assocation rule mining...\n"
$KINGFISHER -i "$TRANSBIRD_FILE.codes" -k170 -M-5 -q300 -o $RULES_FILE

printf "\nConvert bird rules from codes to names...\n"
$NAMESCODE -c $RULES_FILE -t $NUMCODE_FILE

echo "Analysis complete! Rules with names are saved in $RULES_FILE.names"
