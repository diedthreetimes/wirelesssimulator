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

command = 1;


%% Do Search
if command == 1
    ms = [3; 4; 8]
    ns = [2; 3]
    for k = 1:length(ms)
        m = ms(k)
        for p = 1:length(ns)
            n = ns(p)
            per = all_codes(m, n);

            num_best = min(3,length(per));
    
            min_ebno = ones(num_best,1).'*999;
            min_ber = ones(num_best,1).'*0.5;
            best_per = ones(num_best,n)*-1;
    
            figure; hold off;
            for i = 1:length(per)
                [ebnos, bers] = full_ber_curve( per(i,:) );
        
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
    
            figure;
            labels = [];
            mrks = ['-.or'; '-.xb'; '-.*g'; '-.^y'; '-.+k'];
            for i=1:length(best_per)
                % We found a decent code
                if min_ebno(i) < 999
                    [ebnos, bers] = full_ber_curve( best_per(i,:), 0, strcat('Comparison of codes for (',num2str(m),',',num2str(n),')'), mrks(i,:) );
                    hold all;
                end
                labels = [labels; strcat('(', num2str(best_per(i,:)), ')')];
            end
            legend(labels);

            mkdir('problem1/');
            saveas(gcf, strcat('problem1/',num2str(m),'_',num2str(n)), 'fig');
    
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
    
end


%print(gcf, 'ebno.png', '-dpng')
