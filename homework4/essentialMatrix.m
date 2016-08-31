function E = essentialMatrix(F, K1, K2)
% this funchtion is used to compute essential matrix
% F is fundamental matrix
% K1 and K2 are calibration matrix

E = K2' * F * K1;

end

