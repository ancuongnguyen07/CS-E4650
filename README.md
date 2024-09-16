# CS-E4650: Methods of Data Mining

This repo stores collaborated group assignments during the course

## How to get started

### Install prerequisites
Some python packages/libraries are needed
```
numpy
pandas
matplotlib
scikit-learn
```

For writting a homework report, we are encouraged to use [LATEX](https://www.latex-project.org/about/)

### Start a new homework
Create a new folder containing a report template
```sh
./starter.sh <homework_number>
```
For example, to start a Homework 3, you run the following command:
```sh
./starter.sh 3
```
which generates folder `hw3` containing report template. And the TeX files for sections
should be stored in `hw3/tex`. References should be added into `hw3/references.bib`.

### Build a PDF report
```sh
# make sure you are in the homework-specific directory
# `hw3` as in the above example, then the following command
make
```
The final PDF file should be stored at `build` folder.
