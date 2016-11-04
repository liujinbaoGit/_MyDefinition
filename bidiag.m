function m = bidiag(a0,b1,uorl)
% bidiag(a0,b1,uorl)        the sparse matrix
% a0 is the diagonal vector, b1 is the other one. uorl is 'u' or 'l';
% [a1, b2,           ]         [a1,               ]
% [    a2, b3,       ]         [b1, a2,           ]
% [        a3, b4,   ]    or   [    b2, a3,       ]   
% [            a4, b5]         [        b3, a4,   ]
% [                a5]         [            b4, a5]
switch uorl
    case 'u'
        m = diag(a0) + diag(b1(2:end),1);
    case 'l'
        m = diag(a0) + diag(b1(1:end-1),-1);
end
m = sparse(m);
end