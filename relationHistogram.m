filename = 'matrices.csv';
T = readtable(filename);

rows = (T.conv0 == 1 | T.conv1 == 1);
convergedRows = T(rows,:);

histogram(convergedRows.relation, 15);