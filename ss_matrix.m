filename = 'matrices.csv';
if ~isfile(filename)
    cHeader = {'ProblemId' 'ProblemName' 'conv0' 'it0' 'conv1' 'it1' 'relation' 'isEffective'};
    textHeader = strjoin(cHeader, ',');
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
end

data = readcell(filename);
T = readtable(filename);
existedIds = T.ProblemId;

index = ssget;

% example
%ids = find (index.numerical_symmetry ~= 1 & index.nrows <= 1500 & index.ncols <= 1500);
%[ignore, i] = sort (index.nnz (ids));

ids = find (index.nrows <= 5000 & index.ncols <= 5000 & index.nrows == index.ncols);
% you can find list of parameters in ssweb.m

for id = ids(1:1000)
    if (~ismember(id, existedIds))
    %if (id == 141)
        Prob = ssget (id);
        disp(['-------------', Prob.name , ':::', num2str(id), '-------------']);

        A = getMatrix(Prob.A);
    
        try
            ProblemName = string(Prob.name);
            ProblemId = Prob.id;
            [conv0, it0, conv1, it1, relation] = getEffective(A);
            isEffective = (conv1 == 1) & ((conv0 == 0) | (relation > 10));

            newRow = {ProblemId ProblemName conv0 it0 conv1 it1 relation isEffective};
            data = [data;newRow];
            writecell( data, filename);
        catch ME
            fprintf(2, [ME.identifier ,'\n']);
        end 
    end
end

