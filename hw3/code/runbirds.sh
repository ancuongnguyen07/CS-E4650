#!/bin/bash

# The script will exit immediately if any commands returns a non-zero exit status
set -e

NOTEBOOK_FEAT_TRANS="./feat_to_trans.ipynb"
PYTHON_SCRIPT_PATH="./solution.py"
NOTEBOOK_INTERESTING_RULES="./rule_expl.ipynb"
KINGFISHER="./kingfisher/kingfisher"
NAMESCODE="./namecodes/namescodes"

RESULT_FILES_CONTAINER="./results"
TRANSBIRD_FILE="$RESULT_FILES_CONTAINER/transbird.csv"
NUMCODE_FILE="$RESULT_FILES_CONTAINER/birdtable.txt"
RULES_FILE="$RESULT_FILES_CONTAINER/birdrules.txt"

CONSTRAINTS_FILE="data/birdconstraints.txt"

USE_CONSTRAINST=false
GOODNESS_MEASUREMENT=4
if [[ $GOODNESS_MEASUREMENT -eq 4 ]]; then
    GOODNESS_MEASUREMENT_NAME="MI"
elif [[ $GOODNESS_MEASUREMENT -eq 3 ]]; then
    GOODNESS_MEASUREMENT_NAME="chi2"
elif [[ $GOODNESS_MEASUREMENT -eq 2 ]]; then
    GOODNESS_MEASUREMENT_NAME="ln(p)"
elif [[ $GOODNESS_MEASUREMENT -eq 3 ]]; then
    GOODNESS_MEASUREMENT_NAME="Fisher's p"
fi

### Handling parameters
usage() {
    echo "Usage: $0 [-h] [-c]"
    echo "  -h      Print this help message"
    echo "  -c      Rule Constraint mode"
}

while getopts ":ch" opt; do
    case ${opt} in
    c)
        USE_CONSTRAINST=true
        ;;
    h)
        usage
        exit 0
        ;;
    \?)
        echo "Invalid option: -$OPTARG"
        usage
        exit 1
        ;;
    esac
done
###

printf "\nConvert Jupyter Notebook to Python script....\n"
jupyter nbconvert --to python --output $PYTHON_SCRIPT_PATH $NOTEBOOK_FEAT_TRANS

if [[ ! -d $RESULTS_FILE_PREFIX ]]; then
    mkdir -p $RESULT_FILES_CONTAINER
fi

printf "\nRun the transaction-exploring Python script...\n"
python $PYTHON_SCRIPT_PATH $RESULT_FILES_CONTAINER

printf "\nConvert bird transactions to numerical codes...\n"
# -L for creating a new rule table file
$NAMESCODE -n $TRANSBIRD_FILE -t $NUMCODE_FILE -L

if $USE_CONSTRAINST; then
    printf "\nConvert constraints to numerical codes...\n"
    $NAMESCODE -n $CONSTRAINTS_FILE -t $NUMCODE_FILE
fi

printf "\nRun Kingfisher for assocation rule mining...\n"
# Use MI as the goodness measurement method -w4
# The intial threshold for MI is 0.5
$KINGFISHER -i "$TRANSBIRD_FILE.codes" -k170 -M0.5 -w4 -q300 -o $RULES_FILE

printf "\nConvert bird rules from codes to names...\n"
$NAMESCODE -c $RULES_FILE -t $NUMCODE_FILE

# Prepend a header line to rule file CSV
HEADER="Rule,Confidence,Lift,Leverage,$GOODNESS_MEASUREMENT_NAME"
RULES_FILE_NAME="$RULES_FILE.names"
echo "$HEADER" >"$RULES_FILE_NAME.csv"
cat "$RULES_FILE_NAME" >>"$RULES_FILE_NAME.csv"

echo "======================"
echo "Analysis complete! Rules with names are saved in $RULES_FILE_NAME"
echo "======================"

printf "\nFind interesting rules...\n"
jupyter nbconvert --execute --to notebook --inplace $NOTEBOOK_INTERESTING_RULES

printf "\nCleaning up...\n"
rm ./*.py

echo "======================"
echo "All steps have been executed successfully!!!"
echo "======================"
