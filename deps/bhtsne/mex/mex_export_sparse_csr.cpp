/*=================================================================
* fulltosparse.c
* This example demonstrates how to populate a sparse
* matrix.  For the purpose of this example, you must pass in a
* non-sparse 2-dimensional argument of type double.

* Comment: You might want to modify this MEX-file so that you can use
* it to read large sparse data sets into MATLAB.
*
* This is a MEX-file for MATLAB.  
* Copyright 1984-2011 The MathWorks, Inc.
* All rights reserved.
*=================================================================*/

/* $Revision: 1.5.6.3 $ */

#include <math.h> /* Needed for the ceil() prototype */
#include <mex.h>

#include <map>
#include <vector>

#include <iostream>

void mexFunction(
		 int nlhs,       mxArray *plhs[],
		 int nrhs, const mxArray *prhs[]
		 )
{
    /* Declare variable */
    mwSize in_m, in_n;
    mwSize in_nzmax;
    mwIndex  *out_ir, *in_ir, *out_jc, *in_jc;

    double *out_pr, *in_pr, *out_valid_pr, *out_bw_matching_pr;
    double * order;
    double percent_sparse;
    
    /* Check for proper number of input and output arguments */
    if (nrhs != 1) {
        mexErrMsgIdAndTxt( "MATLAB:fulltosparse:invalidNumInputs",
                "Two input argument required.");
    }
    if(nlhs > 2){
        mexErrMsgIdAndTxt( "MATLAB:fulltosparse:maxlhs",
                "Too many output arguments.");
    }
    
    /* Check data type of input argument  */
    if (!(mxIsDouble(prhs[0]))){
        mexErrMsgIdAndTxt( "MATLAB:fulltosparse:inputNotDouble",
                "Input argument must be of type double.");
    }
    
    if (mxGetNumberOfDimensions(prhs[0]) != 2){
        mexErrMsgIdAndTxt( "MATLAB:fulltosparse:inputNot2D",
                "Input argument must be two dimensional\n");
    }

    /* TODO check the input is sparse */
    
    /* Get the size and pointers to input data */
    in_m  = mxGetM(prhs[0]);
    in_n  = mxGetN(prhs[0]);
    in_pr = mxGetPr(prhs[0]);
    in_ir = mxGetIr(prhs[0]);
    in_jc = mxGetJc(prhs[0]);
    in_nzmax = mxGetNzmax(prhs[0]);

    std::cout << in_n << " " << in_m << " " << in_nzmax << std::endl;

    FILE *h;
    if((h = fopen("sparse.dat", "w+b")) == NULL) {
        printf("Error: could not open data file.\n");
        return;
    }
    int n = (int) in_n;
    int nc = n + 1;
    int nnz = (int) in_nzmax;
    fwrite(&n, sizeof(int), 1, h);
    fwrite(&nnz, sizeof(int), 1, h);
    //Convert jc to unsigned int
    unsigned int * ui_jc = (unsigned int*) malloc( nc * sizeof(unsigned int));
    for (int i = 0; i< nc ; i++)
    {
        ui_jc[i] = in_jc[i];
	//std::cout << i  << " " << ui_jc[i] << std::endl;
    }
    unsigned int * ui_ir = (unsigned int*) malloc( nnz * sizeof(unsigned int));
    for (int i = 0; i<nnz; i++)
    {
        ui_ir[i] = in_ir[i];
    }
    fwrite(ui_jc, sizeof(unsigned int), nc, h);
    fwrite(ui_ir, sizeof(unsigned int), nnz, h);
    fwrite(in_pr, sizeof(double), nnz, h);
    fclose(h);

    free(ui_jc); ui_jc = NULL;
    free(ui_ir); ui_ir = NULL;
    

    return;
    
    
    bool matched[in_n];
    for (int i = 0; i<in_n; i++) {
        matched[i] = false;
    }

    std::vector<std::vector<int> > matching;
    matching.resize(in_n);

    //Internal sparse matrix representation
    std::map<int, std::map<int, double> > mat;

    int cidx = 0;
    /* Iterate on n columns */
    for (int c=0; (c<in_n); c++) {
        //Copy jc buffer
        //out_jc[c] = in_jc[c];

        cidx = (int)(order[c] - 1); //change to unified ids

        //mexPrintf("%i\n", (int)order[j]);
        mwSize r;
        double maxv = 0;
        int best_id = -1;
        /* Iterate on rows */
        for (r=in_jc[cidx]; (r< in_jc[cidx+1]); r++) {
            mat[cidx][in_ir[r]] = in_pr[r];

            //mexPrintf("c: %i, r:%i, v:%f\n", cidx, in_ir[r], in_pr[r]);
            
            if (!matched[cidx]) {
                if (in_pr[r] > maxv) {
                    maxv = in_pr[r];
                    //Store best matching row
                    best_id = in_ir[r];
                }
            }
        }
        if (!matched[cidx]) {
            if (maxv > 0 && !matched[best_id]) {
                matched[cidx] = true;
                matched[best_id] = true;

                matching[cidx].push_back(best_id);
                matching[best_id].push_back(cidx);

                //mexPrintf(" (%i %i) \n", cidx, best_id);
            }
        }
    }
    //out_jc[in_n] = in_jc[in_n];

    // for (std::map<int, std::vector<int> >::iterator it=matching.begin(); it!=matching.end(); ++it) {
    //     //mexPrintf("matching %i :\n ", it->first);
    //     for (size_t i = 0; i<it->second.size(); i++) {
    //         mexPrintf(" %i ", it->second[i]);
    //     }
    //     mexPrintf("\n");
    // }

    /*
    bool valid[in_n];
    for (int i = 0; i<in_n; i++) {
        valid[i] = true;
    }
    */
   

}
