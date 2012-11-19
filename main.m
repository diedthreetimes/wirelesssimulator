open_system('link_layer_simulator');


global trellis use_rayleigh use_dbpsk m ebno;

trellis = poly2trellis(1, 1);
use_rayleigh = 0;
use_dbpsk = 0;
m = 1;
ebno = 0;



full_ber_curve( poly2trellis(2, [1 3]) )



%print(gcf, 'ebno.png', '-dpng')
