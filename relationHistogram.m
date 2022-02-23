filename = 'matrices.csv';
T = readtable(filename);
relation = T.relation;
histogram(relation,15);