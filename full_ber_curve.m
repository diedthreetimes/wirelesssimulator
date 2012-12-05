function [ ebnos, bers ] = full_ber_curve( code, ray, tit)
%FULL_BER_CURVE Calculate and plot BER Curve
%   Will run the simulation until 1e-5 error rate is achieved
%   link_layer_simulator must be opened

global trellis use_rayleigh use_dbpsk m ebno no_csi use_soft no_interleave rand_seed;

if nargin < 2
    use_rayleigh = 0;
else
    use_rayleigh = ray
end  

m = floor(log2(max(code)))+1;

ebnos = [];
bers = [];
ebno = 0;
ber = 1;
max_ebno = 100;

trellis = poly2trellis(m, code);

detailed = 1;
if detailed
    ebno = 28;
    max_ebno = 32;
end

while (detailed || ber > 1e-5) && ebno <= max_ebno    
    [t,x,y] = sim('link_layer_simulator');
    
    ber = y(1);
    bers = [bers ber];
    ebnos = [ebnos ebno];
    
    rand_seed = randi(1000000,1);
    
    % As we approach the desired ber value,
    % we need to increment ebno by smaller
    % values or we will hit ber=0 and then
    % Matlab can't plot it since it's on a
    % log scale.
    if detailed
        ebno = ebno + 0.25;
    else
        if ber < 5e-3
            ebno = ebno + 0.3;
        elseif ber < 1e-2
            ebno = ebno + 0.5;
        elseif ber < 1e-1
            ebno = ebno + 1;
        else
            ebno = ebno + 5;
        end
    end
end


semilogy(ebnos,bers,'-.or'); %hold on;
if(nargin < 3)
    title(['Performance for ' int2str(code)]);
else
    title(tit);
end
xlabel('E_b/N_0');
ylabel('Bit Error Rate');

end

