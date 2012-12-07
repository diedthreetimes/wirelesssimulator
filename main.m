open_system('link_layer_simulator');

global trellis use_rayleigh use_dbpsk m n ebno no_csi use_soft no_interleave rand_seed doppler_shift;


%%%%%%%%%%%%%%%%%%%%%   Configuration Paramaters  %%%%%%%%%%%%%%%%%%%%
n = 2;             % R inverse (the rate of expansion of bits to coded bits)
m = 3;             % The number of look back bits (memory registers)
no_csi = 1;        % Turn Channel State Information off
use_soft = 0;      % Use soft decision decoding (instaed of hard decision)
no_interleave = 0; % Turn off block interleaving
use_dbpsk = 0;     % Use dbpsk instead of bpsk modulation
rayleigh = 1;      % Use flat rayleigh fading in addition to AWGN
code = [5 7];      % A convolution code (matching m and n) specified in decimal 
slow_vehicle = 1;  % Vehicle speed. Slow is 3km/h. Not slow is 120km/h 

%Commands
% 1: Run the search algorithim with above settings
% 2: Run problem 4. The above settings don't affect it
% 3: Plot a single ber curve with the above settings
command = 1;

%Command specific paramaters

% Search space commands (will search all combinations
ms = [3; 4];  % Which m's to search 
ns = [2; 3];  % Which n's to search
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% Doppler shifts are calculated using a 900MHz carrier frequency
%  These could easily be calculated on the fly
if slow_vehicle
    doppler_shift = 2.5;
else 
    doppler_shift = 100;
end


%% Do Search
if command == 1   
    for k = 1:length(ms)
        m = ms(k)
        for p = 1:length(ns)
            n = ns(p)
            per = all_codes(m, n);
            
            num_best = min(3,size(per,1));
    
            min_ebno = ones(num_best,1).'*999;
            min_ber = ones(num_best,1).'*0.5;
            best_per = ones(num_best,n)*-1;

            figure; hold off;
            for i = 1:size(per,1)
                [ebnos, bers] = full_ber_curve( per(i,:), rayleigh );
                target_ebno = 999;
                target_ber = 1;
                for j=1:length(ebnos)
                    if target_ebno == 999 && bers(j) < 1e-3
                        target_ebno = ebnos(j);
                        target_ber = bers(j);
                    end    
                end
        
                % Find the worst of our saved best codes (specified by index)
                ind = find(min_ebno == max(min_ebno));
                ind = find(min_ber == max(min_ber(ind)) ); % Handle ebno ties
                ind = ind(1);
        
                % Ebno strictly less
                if target_ebno < min_ebno(ind)
                    min_ebno(ind) = target_ebno;
                    min_ber(ind) = target_ber;
                    best_per(ind,:) = per(i,:);         
                % Ebno is just as good but ber is better
                elseif target_ebno == max(min_ebno) && min_ber(ind) > target_ber
                    min_ebno(ind) = target_ebno;
                    min_ber(ind) = target_ber;
                    best_per(ind,:) = per(i,:);
                end
            end
            close gcf;
            
            figure;
            labels = {};
            mrks = ['-.or'; '-.xb'; '-.*g'; '-.^y'; '-.+k'];
            for i=1:size(best_per,1)
                % We found a decent code
                if min_ebno(i) < 999
                    [ebnos, bers] = full_ber_curve( best_per(i,:), rayleigh, strcat('Comparison of codes for (',num2str(m),',',num2str(n),')'), mrks(i,:) );
                    hold all;
                end
                labels = [labels; strcat('(', num2str(best_per(i,:)), ')')];
            end
            legend(labels);

            dir = 'problem1/'
            if rayleigh
                dir = strcat(dir, 'rayleigh/')
            end
            if use_dbpsk
                dir = strcat(dir, 'dbpsk/')
            end
            mkdir(dir);
            saveas(gcf, strcat(dir,num2str(m),'_',num2str(n)), 'fig');
    
            min_ebno
            min_ber
            best_per
    
            best_ind = find(min_ebno == min(min_ebno));
            best_ind = find(min_ber == min(min_ber(best_ind)));
            best_ind = best_ind(1)
    
            best_per(best_ind,:)
            min_ebno(best_ind)
            min_ber(best_ind)
        end
    end   
%% Problem 4
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
    
elseif command == 3
    full_ber_curve(code, rayleigh);
end


%print(gcf, 'ebno.png', '-dpng')
