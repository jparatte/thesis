#!/bin/bash

mkdir -p sparsetsne/build
cd sparsetsne/build
cmake ..
make
cp bhtsne ../../sparse_tsne
cd ../../mex
matlab -nodisplay -nosplash -nodesktop -r "compile_mex;exit;"
mv mex_export_sparse_csr.mex* .. 
