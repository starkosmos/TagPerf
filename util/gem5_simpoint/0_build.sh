#!/bin/sh

cd ..
scons build/ALL/gem5.opt -j32
cd - > /dev/null