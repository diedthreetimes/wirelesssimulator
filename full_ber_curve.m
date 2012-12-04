function [ ebnos, bers ] = full_ber_curve( code, ray, dbpsk)
%FULL_BER_CURVE Calculate and plot BER Curve
%   Will run the simulation until 1e-5 error rate is achieved
%   link_layer_simulator must be opened

global trellis use_rayleigh use_dbpsk m ebno no_csi use_soft;

if nargin < 2
    use_rayleigh = 0;
else
    use_rayleigh = ray
end
if nargin < 3
    use_dbpsk = 0;
else
    use_dbpsk = dbpsk
end  

m = floor(log2(max(code)))+1;

ebnos = [];
bers = [];
ebno = 0;
ber = 1;
max_ebno = 500
trellis = poly2trellis(m, code)

while ber > 1e-5 && ebno < max_ebno    
    [t,x,y] = sim('link_layer_simulator');
    
    ber = y(1);
    bers = [bers ber];
    ebnos = [ebnos ebno];
    ebno = ebno + 5
end

plot(ebnos,bers,'-.or'); %hold on;
title(['Performance for ' int2str(code)]);
xlabel('E_b/N_0');
ylabel('Bit Error Rate')

end

