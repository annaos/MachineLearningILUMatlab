function [isEffective] = isEffective(A)
    quotient = getEffective(A);
    isEffective = quotient < 10;
end