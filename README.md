# Graph-based Methods for Visualization and Clustering

Examples, experiments, algorithms and any code needed to reproduce the results in my PhD Thesis


Although this code should run on any OS and support Octave, it was only tested in a GNU/Linux environment with Matlab. The installation instructions given in this README only cover this case 

## Install

1. Requirements
  - a c++ compiler supporting c++11
  - a working Matlab environment with mex compilation
  - for LargeVis, GSL is needed 
  `sudo apt install libgsl-dev`

2. Build dependancies
  - BH t-SNE : run the script in deps/bhtsne/build.sh
  - LargeVis : run the script in deps/largevis/build.sh

3. Configure the GSPBox

4. Setup the parameters
  - Copy the file configTemplate.m to create a local config file
  `cp configTemplate.m config.m`
  And edit the file to setup at least the GLOBAL_dataprefix variable and the number of cores for parallel processing

5. Init and run the test
  - This toolbox needs to be started with the init.m script before use, to setup the global variables and the paths, so in matlab simply run, `init` from the root folder of the project
  - Run the fast test suite to check that everything was installed as planned
  `fast_test_suite`

6. You are good to go ! Check the file demo.m to understand how to use the toolbox

## Known issues

- In Ubuntu 16.04 with Matlab R2016b, the c++ standard library needs to be preloaded manually to match with the FLANN version. Start Matlab with 
`LD_PRELOAD=/usr/lib64/libstdc++.so.6 matlab &`
