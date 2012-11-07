open_system('link_layer_simulator')
ebnos = 10:5:50;

for i = 1:length(ebnos)
    ebno = ebnos(i);
    [t,x,y] = sim('link_layer_simulator');
    plot(ebno,y(1),'-.or'); hold on;
end
title('Bit Error Rate vs E_b/N_0')
xlabel('E_b/N_0');

print(gcf, 'ebno.png', '-dpng')