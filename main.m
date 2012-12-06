open_system('link_layer_simulator');

global trellis use_rayleigh use_dbpsk m n ebno no_csi use_soft no_interleave rand_seed doppler_shift;

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

command = 2;


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
    
    n = 2;
    m = 3;
    no_csi = 1;
    use_soft = 0;
    no_interleave = 0;
    use_dbpsk = 0;
    doppler_shift = 2.5;
    
    %% SDD vs HDD over AWGN
    mkdir 'problem4/awgn';
    use_soft = 0;
    figure; 
    full_ber_curve( code, 0, 'HDD over AWGN', '-.or')
    hold all;
       
    use_soft = 1;
    full_ber_curve( code, 0, 'HDD vs SDD over AWGN', '-.xb')
    legend('HDD', 'SDD');
    saveas(gcf, 'problem4/awgn/hddvssdd','fig');
    
    
    %% With and without csi
    mkdir 'problem4/ray';
    no_csi = 0;
    use_soft = 0;
    figure
    full_ber_curve( code, 1, 'HDD +CSI over flat rayleigh', '-.or')
    hold all;
    
    use_soft = 1;
    full_ber_curve( code, 1, 'SDD +CSI over flat rayleigh', '-.xb')
    
    no_csi = 1;
    use_soft = 0;
    full_ber_curve( code, 1, 'HDD -CSI over flat rayleigh','-.*g')
    
    use_soft = 1;
    full_ber_curve( code, 1, 'HDD vs SDD over flat rayleigh w and w/o CSI','-.^y')
    legend('HDD+CSI','SDD+CSI','HDD-CSI','SDD-CSI');
    saveas(gcf, 'problem4/ray/csi','fig');
    
    %% Interleaving
    use_soft = 0;
    no_interleave = 1;
    no_csi = 1;
    figure
    full_ber_curve( code, 1, 'HDD -CSI no interleaving over flat rayleigh','-.or')
    hold all;
    
    no_interleave = 0;
    full_ber_curve( code, 1, 'interleaving vs no interleaving with HDD-CSI and flat rayleigh','-.xb')
    legend('No Interleave', 'Interleave')
    saveas(gcf, 'problem4/ray/interleave', 'fig')
    
    %% Mobility
    no_interleave = 0;
    use_soft = 0;
    
    figure
    doppler_shift = 2.5;
    full_ber_curve(code, 1, 'Low vs High mobility over flat rayleigh', '-.or')
    hold all;
    doppler_shift = 100;
    full_ber_curve(code, 1, 'Low vs High mobility over flat rayleigh', '-.xb')
    legend('Low Mobility', 'High Mobility')
    saveas(gcf, 'problem4/ray/mobility', 'fig')
    
    %% DBPSK
    no_interleave = 0;
    use_soft = 0;
    use_dbpsk = 1;
    
    figure
    doppler_shift = 2.5;
    full_ber_curve(code, 1, 'Low vs High mobility over flat rayleigh', '-.or')
    hold all;
    doppler_shift = 100;
    full_ber_curve(code, 1, 'Low vs High mobility over flat rayleigh using DBPSK', '-.xb')
    legend('Low Mobility', 'High Mobility')
    saveas(gcf, 'problem4/ray/dbpsk-mobility', 'fig')
    
end


%print(gcf, 'ebno.png', '-dpng')
