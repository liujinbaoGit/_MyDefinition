function m = tridiag(a1,b2,c3)
% tridiag(a1,b2,c3)     the sparse matrix
% [b1, a2,           ]
% [c1, b2, a3,       ]
% [    c2, b3, a4,   ]
% [        c3, b4, a5]
% [            c4, b5]

m = sparse(diag(a1(2:end),1) + diag(b2) + diag(c3(1:end-1),-1));

end

