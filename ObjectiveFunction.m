function[o]=ObjectiveFunction(x)

    %o = sum(x.^2);% OSphere Testfunction
    
    x = x-[-10,-10];
    o = sum ( abs(x) ) + prod( abs(x) );
    o = o + 100;
    
    %o = sum(x)./(1+sum(x.^2));

    
end