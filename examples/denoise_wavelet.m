function [ img_denoised ] = denoise_wavelet( img_noisy )
%DENOISE_WAVELET Summary of this function goes here
%   Detailed explanation goes here
    wname = 'bior3.5';
    level = 5;

    [C,S] = wavedec2(img_noisy,level,wname);

    thr = wthrmngr('dw2ddenoLVL','penalhi',C,S,3);
    sorh = 's';
    [img_denoised,cfsDEN,dimCFS] = wdencmp('lvd',C,S,wname,level,thr,sorh);

end

