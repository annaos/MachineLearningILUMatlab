function [it0, it1, relation] = getEffective(A)

    n = size(A, 1);

    x0 = sum(A,1).';
    b = A*x0;
    
    tol = 1e-6; % maybe smaller/bigger
    maxit = n;

    [x,fl0,rr0,it0,rv0] = gmres(A,b,[],tol,maxit);
    error = norm(x0-x);
    disp('gmres error:');
    disp(error);

    [L,U] = ilu(A,struct('type','nofill'));
    [x1,fl1,rr1,it1,rv1] = gmres(A,b,[],tol,maxit,L,U);
    error = norm(x0-x1);
    disp('gmres with ILU error:');
    disp(error);

    %fprintf('%d / %d \n',it0(2),it1(2));

    if (fl0 == 0 & fl1 ==0) %TODO check x and x1 
        relation = it0(2) / it1(2);
        it0 =it0(2);
        it1 =it1(2);
    else
        disp(['!!!!Exception error: ', error]);
        ME = MException('GetEffective:notConverged', 'gmres does not converged');
        throw(ME)
    end
end