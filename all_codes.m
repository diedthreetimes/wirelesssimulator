function [ per ] = all_codes( m, n )
%ALL_CODES Return all valid convolution codes
%   Detailed explanation goes here

    per = [];
    combs = combntns(1:2^(m)-1, n);

    for i = 1:size(combs,1)
        if ~valid_trellis(m, combs(i,:)) 
            continue;
        end
        
        % Permutations are not necessary
        per = [per; combs(i,:)];
        %per = [per; perms(combs(i,:))];
    end

end

