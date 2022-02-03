rng default;

sizes = [100:50:1000];
density = 0.1; %0.01-0.05 - or as in sparse suite
densities = [0.01:0.01:0.1];

quotient = zeros(1, size(sizes, 1));
counter = 1;

for s = sizes
    for d = densities
        A = sprandn(s,s,d) + 12*speye(s);
    
        try
            quotient(counter) = getEffective(A);
            counter = counter + 1;
        catch ME
            fprintf(2, [ME.identifier ,'\n']);
        end 
    end 

end
quotient = quotient(1:counter-1);

disp(quotient);
histogram(quotient);