index = ssget ;           % get index of the SuiteSparse Matrix Collection
% you can find list of parameters in ssweb.m

% example
%ids = find (index.numerical_symmetry == 1) ;
%[ignore, i] = sort (index.nnz (ids)) ;

%ids = find (& index.nrows <= 1500 & index.ncols <= 1500) ;
ids = find (index.numerical_symmetry ~= 1 & index.nrows == index.ncols) ;

n = size(ids, 2);
data = [string(1:n); zeros(1, n); zeros(1, n); zeros(1, n); zeros(1, n); zeros(1, n); zeros(1, n)];

counter = 1;
for id = ids(1:600)

    Prob = ssget (id);
    % disp(['-------------', Prob.name ,'-------------']);
    A = Prob.A ;

    try
        data(1, counter) = string(Prob.name);
        data(2, counter) = Prob.id;
        [data(3, counter), data(4, counter), data(5, counter)] = getEffective(A);
        data(6, counter) = str2double(data(5, counter)) > 10; % isEffective
        data(7, counter) = nnz(A)/numel(A); % density

        counter = counter + 1;
    catch ME
        fprintf(2, [ME.identifier ,'\n']);
    end 

end
data = data(:,1:counter-1);

ProblemName = data(1,:).';
ProblemId = data(2,:).';
it0 = str2double(data(3,:)).';
it1 = str2double(data(4,:)).';
relation = str2double(data(5,:)).';
isEffective = data(6,:).';
density = str2double(data(7,:)).';

disp(mean(density));
density = density(1:counter-1);
i = ceil(counter / 50);
density = sort(density);
density = density(1+i:counter-1-i);
disp(mean(density));

histogram(relation,15);

T = table(ProblemId,ProblemName, it0, it1, relation, isEffective);
writetable(T,'matrices.csv','Delimiter',',','QuoteStrings',true)
