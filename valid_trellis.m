function [ out ] = valid_trellis( m, poly )
%VALID_TRELLIS are these valid paramaters
%   ensures the poly covers all history bits

    % We need to check that each register is used at least once (and not more than m)
    
    % First or all the polynomails to gether
    or = 0;
    for i = 1:length(poly)
       or = bitor(or, poly(i));
    end
    
    % Then check that there are m bits and all equal to one
    out = or == 2^m-1;

end

