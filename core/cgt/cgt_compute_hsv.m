function [ hsv_encoding ] = cgt_compute_hsv(tree, level)
%CGT_COMPUTE_HSV Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('level', 'var')
       level = tree.depth + 1; 
    end
    
    [N, Nl] = size(tree.encoding);
    encoding_coeffs = int32(zeros(N, Nl));
    
    Nl_expected = round(log(tree.size) / log(tree.branching));
    Nl = min(Nl, Nl_expected+1);
    
    wh = 2;
    ws = 1;
    wv = 1;
    w = wh + ws + wv;
    
    ncycle = idivide(int32(Nl), int32(w));
    nrem = mod(int32(Nl), int32(w));
    
    nh = ncycle*wh;
    ns = ncycle*ws;
    nv = ncycle*wv;
    
    if nrem >= wh
       nh = nh + wh; 
       nrem = nrem - wh;
    else
       nh = nh + nrem;
       nrem = 0;
    end
    
    if nrem >= ws
       ns = ns + ws; 
       nrem = nrem - ws;
    else
       ns = ns + nrem;
       nrem = 0;
    end
    
    if nrem >= wv
       nv = nv + wv; 
       nrem = nrem - wv;
    else
       nv = nv + nrem;
       nrem = 0;
    end
    
    if (nh + ns + nv > Nl)
        error('Number of channels bigger than number of levels');
    end
    
    
    K = int32(tree.branching);
    
    fprintf('Color channels assignments : H=%d (prec=%d), S=%d (prec=%d), V=%d (prec=%d)\n', nh, K^nh, ns, K^ns, nv, K^nv);
    
    curr_vec = tree.encoding(:,1);
    for ii = 1:tree.depth + 1
       encoding_coeffs(:,ii) = mod(curr_vec, K);
       curr_vec = idivide(curr_vec, K);
    end
    
    %Process H-values
    offset = Nl+1;
    hvalues = int32(zeros(N, 1));
    for ii = 1:nh
        hvalues = hvalues.*K + encoding_coeffs(:,offset-ii);
    end
    h = double(hvalues) / double(K^nh);

    %Process S-values
    offset = offset - nh;
    svalues = int32(zeros(N, 1));
    for ii = 1:ns
        svalues = svalues.*K + encoding_coeffs(:,offset-ii);
    end
    s = 1 - 0.5*(double(svalues) / double(K^ns));
    
    %Process V-values
    offset = offset - ns;
    vvalues = int32(zeros(N, 1));
    for ii = 1:nv
        vvalues = vvalues.*K + encoding_coeffs(:,offset-ii);
    end
    v = 1 - 0.5*(double(vvalues) / double(K^nv));
    
    hsv_encoding = [h, s, v];    
end

