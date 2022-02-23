filename = 'matrices.csv';
if ~isfile(filename)
    cHeader = {'ProblemId' 'ProblemName' 'it0' 'it1' 'relation' 'isEffective'};
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
%ids = find (index.numerical_symmetry == 1) ;
%[ignore, i] = sort (index.nnz (ids)) ;

%ids = find (& index.nrows <= 1500 & index.ncols <= 1500) ;
ids = find (index.numerical_symmetry ~= 1 & index.nrows <= 5000 & index.ncols <= 5000 & index.nrows == index.ncols) ;
% you can find list of parameters in ssweb.m

for id = ids(1:5)
    if (~ismember(id, existedIds))
        Prob = ssget (id);
        % disp(['-------------', Prob.name ,'-------------']);
        A = Prob.A ;
    
        try
            ProblemName = string(Prob.name);
            ProblemId = Prob.id;
            [it0, it1, relation] = getEffective(A);
            isEffective = str2double(relation) > 10;

            newRow = {ProblemId ProblemName it0 it1 relation isEffective};
            data = [data;newRow];
            writecell( data, filename);
        catch ME
            fprintf(2, [ME.identifier ,'\n']);
        end 
    end

end

%T = table(ProblemId,ProblemName, it0, it1, relation, isEffective);
% writetable(T,filename,'Delimiter',',','QuoteStrings',true)
