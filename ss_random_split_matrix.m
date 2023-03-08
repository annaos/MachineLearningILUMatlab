filename = 'matrices_partial_1.csv';
if ~isfile(filename)
    cHeader = {'problem_id' 'problem_name' 'conv0' 'it0' 'conv1' 'it1' 'relation' 'is_effective'};
    textHeader = strjoin(cHeader, ',');
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
end

data = readcell(filename);
original_filename = 'original.csv';% filter ids from this file
T = readtable(original_filename);
existedIds = T.ProblemId;

warning('off')


N = 40000;


index = ssget;
ids = find (index.nrows >= 101 & index.nrows <= 100000 & index.nrows == index.ncols);

%for existedId = existedIds'
%    ids = ids(ids~=existedId);
%end
ids_indexes = randi([1 length(ids)],1,N);

for i = [1:N]
    ids_index = ids_indexes(i);
    id = ids(ids_index);

    Prob = ssget (id);
    problem_name = string(Prob.name);

    % disp(['-------------', ProblemName , ':::', num2str(id), '-------------']);

    A = Prob.A;
    n = size(A,1);
    s = randi([100 min(n-1, 2000)]);
    split = randi([1 n-s+1]);
    problem_id = id + "-" + s + "-" + split;


    B = A(split:s+split-1, split:s+split-1);
    try

        [conv0, it0, conv1, it1, relation] = getEffective(B);
        is_effective = (conv1 == 1) & ((conv0 == 0) | (relation > 1.5));

        newRow = {problem_id problem_name conv0 it0 conv1 it1 relation is_effective};
        data = [data;newRow];
    catch ME
        fprintf(2, [ME.identifier ,'\n']);
    end 
    if mod(i, 1000) == 0 
        disp(['--------------------------', num2str(i), ' done--------------------------']);
        writecell( data, filename);
    end
end
writecell( data, filename);

