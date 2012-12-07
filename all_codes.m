function [ per ] = all_codes( m, n )
%ALL_CODES Return all valid convolution codes
%   Detailed explanation goes here

    % Permutations of codes don't matter, grab all combinations
    per = [];
    combs = combntns(1:2^(m)-1, n);

    % For each valid trellis and it to our result vector
    for i = 1:size(combs,1)
        if valid_trellis(m, combs(i,:)) 
            per = [per; combs(i,:)];           
        end
    end
end
