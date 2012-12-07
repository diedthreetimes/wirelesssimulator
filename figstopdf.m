% Convert all figures to pdf

files = [getAllFiles('problem4'); getAllFiles('problem1')]

for i=1:length(files)
    
   % Is this a figure?
   a = regexpi(files(i), '.*\.fig') ;
   if a{1} == 1
    file = files(i);
    file = file{1};
    open(file);
    saveas(gcf, file(1:length(file)-4), 'pdf');
    close gcf;
   end
end