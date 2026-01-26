#!/bin/sh

mkdir ../../gem5/se~
cp [0-4]_*.sh se.py ../../gem5/se~
tar zxf simpoint.tar.gz -C ../../gem5/se~
cd ../../gem5/se~/simpoint/gcc
mkdir 1 2 3 4 5 6 7 8 9
cd - > /dev/null
cd ../../gem5/se~/simpoint/omnetpp
mkdir 1 2 3 4
cd - > /dev/null
cd ../../gem5/se~/simpoint/sjeng
mkdir 1 2 3 4 5 6 7 8 9 10
cd - > /dev/null
cd ../../gem5/se~/simpoint/xalancbmk
mkdir 1 2 3 4 5 6 7 8 9 10 11
cd - > /dev/null
