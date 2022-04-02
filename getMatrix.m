function [R] = getMatrix(B)
    n = size(B, 1);
    if (n > 1000)
        p = symrcm(B);
        R = B(p,p);
    else
        R = B;
    end
end