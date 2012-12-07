function [ ebnos, bers ] = full_ber_curve( code, ray, tit, marker)
%FULL_BER_CURVE Calculate and plot BER Curve
%   Will run the simulation until 1e-5 error rate is achieved
%   link_layer_simulator must be opened

% These need to be global to work with Comm Toolbox
global trellis use_rayleigh use_dbpsk m ebno no_csi use_soft no_interleave rand_seed;

if nargin < 2
    use_rayleigh = 0;
else
    use_rayleigh = ray;
end  

if nargin < 4
    marker = '-.or';
end

% We learn m from the code length
m = floor(log2(max(code)))+1;

ebnos = [];
bers = [];
ebno = 0;
ber = 1;
max_ebno = 20;
trellis = poly2trellis(m, str2num(dec2base(code,8))'); % Trellis expects octal codes

% Detailed mode will just iterate over several ebnos
detailed = 0;
if detailed
    ebno = 0;
    max_ebno = 10;
end

% While we haven't reached the target ber rerun the simulation
while (detailed || ber > 1e-5) && ebno <= max_ebno    
    rand_seed = randi(1000000,1); % Make sure the simulation is random each time
    
    % Run the simulation (ber is an unlisted output)
    [t,x,y] = sim('link_layer_simulator'); 
    
    % Update ber/ebno list
    bers = [bers ber];
    ebnos = [ebnos ebno];

    ebno = ebno + 1;
end



% Plot the ber curve
semilogy(ebnos,bers,marker); %hold on;
if(nargin < 3)
    title(['Performance for ' int2str(code)]);
else
    title(tit);
end
xlabel('E_b/N_0');
ylabel('Bit Error Rate');

end

