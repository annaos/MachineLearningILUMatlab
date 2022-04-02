function [conv0, it0, conv1, it1, relation] = getEffective(A)


    n = size(A, 1);
    restart = min(50,n);

%    x = sum(A,1).';
%    x = A(:,1);
    x = sin((1:n)).';
    b = A*x;
%    b = ones(n,1);
    
    tol = 1e-6;
    tolError = 1e-5;
    maxit = ceil(n/restart);

    [x0,fl0,rr0,it0,rv0] = gmres(A,b,restart,tol,maxit);
    it0 = it0(2) + (it0(1)-1)*restart;
    relError00 = norm(b-A*x0)/norm(b);
    relError01 = norm(x-x0)/norm(x);
    relError0 = relError01;

    %DEBUG
%    if (relError0 > tolError)
%        fprintf(2, ['gmres error ', num2str(relError0) ,'\n']);
%    end

    conv0 = (fl0 == 0) & (relError0 < tolError);

    try
        [L,U] = ilu(A,struct('type','nofill'));
        [x1,fl1,rr1,it1,rv1] = gmres(A,b,restart,tol,maxit,L,U);
        it1 = it1(2) + it1(1)*restart;

        relError10 = norm(b-A*x1)/norm(b);
        relError11 = norm(x-x1)/norm(x);
        relError1 = relError11;

        %DEBUG
%        if (relError1 > tolError)
%            fprintf(2, ['gmres with ILU error ', num2str(relError1) ,'\n']);
%        end

        conv1 = (fl1 == 0) & (relError1 < tolError);

        relation = it0 / it1;

        
    catch ME
        if (strcmp(ME.identifier,'MATLAB:ilu:ZeroPivot'))
            conv1 = false;
            it1 = 0;
            relation = 0;
        else
           rethrow(ME)
        end
    end 


end