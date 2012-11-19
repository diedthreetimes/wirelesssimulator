function [ out ] = valid_trellis( m, poly )
%VALID_TRELLIS are these valid paramaters
%   ensures the poly covers all history bits

    or = 0;
    for i = 1:length(poly)
       or = bitor(or, poly(i));
    end
    
    out = or == 2^m-1;

end

