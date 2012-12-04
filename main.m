open_system('link_layer_simulator');

global trellis use_rayleigh use_dbpsk m ebno no_csi use_soft;

% R inverse (the rate of expansion of bits to coded bits)
n = 2;
% The number of look back bits
m = 2;
no_csi = 1;
use_soft = 1;

per = all_codes(m, n);

for i = 1:length(per)
    figure
    full_ber_curve( per(i,:) )
end


%print(gcf, 'ebno.png', '-dpng')
