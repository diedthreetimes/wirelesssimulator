open_system('link_layer_simulator');

%global trellis use_rayleigh use_dbpsk m ebno;

    
per = all_codes(2, 2);

for i = 1:length(per)
    figure
    full_ber_curve( per(i,:) )
end


%print(gcf, 'ebno.png', '-dpng')
