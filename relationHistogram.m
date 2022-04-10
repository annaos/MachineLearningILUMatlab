filename = 'matrices.csv';
T = readtable(filename);

rowsCount = height(T((T.conv0 == 1),:));
fprintf('gmres converged: %d\n', rowsCount);

rowsCount = height(T((T.conv1 == 1),:));
fprintf('gmres with ilu converged: %d\n', rowsCount);

rowsCount = height(T(((T.conv0 == 1) & (T.conv1 == 0)),:));
fprintf('gmres converged, ilu did not converged: %d\n', rowsCount);

rowsCount = height(T(((T.conv0 == 0) & (T.conv1 == 1)),:));
fprintf('gmres did not converged, ilu converged : %d\n', rowsCount);

rowsCount = height(T((T.isEffective == 1),:));
fprintf('isEffective rows: %d\n', rowsCount);

rows = (T.conv0 == 1 | T.conv1 == 1);
convergedRows = T(rows,:);

fprintf('rows where something converged: %d\n', height(convergedRows));

histogram(convergedRows.relation, 15);