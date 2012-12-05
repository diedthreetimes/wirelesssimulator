open_system('link_layer_simulator');

global trellis use_rayleigh use_dbpsk m ebno no_csi use_soft no_interleave rand_seed doppler_shift;

% R inverse (the rate of expansion of bits to coded bits)
n = 2;
% The number of look back bits
m = 3;
no_csi = 1;
use_soft = 0;
no_interleave = 0;
use_dbpsk = 0;

slow_vehicle = 1;
if slow_vehicle
    doppler_shift = 2.5;
else 
    doppler_shift = 100;
end

command = 1;


% Do Search
if command == 1
    per = all_codes(m, n);

    
    %for i = 1:length(per)
        figure
        %[ebnos, bers] = full_ber_curve( per(i,:) )
        [ebnos, bers] = full_ber_curve( [5 7] )
    %end
% Problem 4
elseif command == 2
    code = [5 7];
    
    m = 3;
    no_csi = 1;
    use_soft = 0;
    no_interleave = 0;
    use_dbpsk = 0;
    doppler_shift = 2.5;
    
    mkdir 'problem4/awgn';
    use_soft = 0;
    figure
    full_ber_curve( code, 0, 'HDD over AWGN')
    saveas(gcf, 'problem4/awgn/hdd','fig');
       
    use_soft = 1;
    figure
    full_ber_curve( code, 0, 'SDD over AWGN')
    saveas(gcf, 'problem4/awgn/sdd','fig');
    
    % With and without csi
    mkdir 'problem4/ray';
    no_csi = 0;
    use_soft = 0;
    figure
    full_ber_curve( code, 1, 'HDD +CSI over flat rayleigh')
    saveas(gcf, 'problem4/ray/hdd+csi', 'fig');
    
    use_soft = 1;
    figure
    full_ber_curve( code, 1, 'SDD +CSI over flat rayleigh')
    saveas(gcf, 'problem4/ray/sdd+csi','fig');
    
    no_csi = 1;
    use_soft = 0;
    figure
    full_ber_curve( code, 1, 'HDD -CSI over flat rayleigh')
    saveas(gcf, 'problem4/ray/hdd-csi','fig');
    
    use_soft = 1;
    figure
    full_ber_curve( code, 1, 'SDD -CSI over flat rayleigh')
    saveas(gcf, 'problem4/ray/sdd-csi','fig');
    
    use_soft = 0;
    no_interleave = 1;
    no_csi = 1;
    figure
    full_ber_curve( code, 1, 'HDD -CSI no interleaving over flat rayleigh')
    saveas(gcf, 'problem4/ray/hdd-csi-intr','fig');
end


%print(gcf, 'ebno.png', '-dpng')
