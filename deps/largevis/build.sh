#!/bin/bash

cd sources
g++ -std=c++11 LargeVis.cpp main.cpp -o LargeVis -lm -pthread -lgsl -lgslcblas -Ofast -march=native -ffast-math

mv LargeVis ..
