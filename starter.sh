#!/bin/bash

HW_DIR="hw$1"

mkdir "$HW_DIR"
cp -r report-template/* "$HW_DIR/"
