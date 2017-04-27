function [ yn ] = baricentroSezioneComposta( profilo, soletta, n, hc, precisione)
%BARICENTROSEZIONECOMPOSTA calcolo del baricentro della sezione composta
% il baricentro della sezione è calcolato con origine all'estradosso
% superiore. Si considera la sezine completamente reagente.

% dati di primo tentativo
if nargin < 5
    precisione = .001;
end
yn0 = hc;
err = 1;
while err > precisione
    if yn0 > soletta.h
        h_calc = soletta.h;
    else
        h_calc = yn0;
    end
    %% contributo cls
    S_cls = soletta.b * h_calc^2/2;
    A_cls = soletta.b * h_calc;
    
    %% contributo acciaio
    S_acc = n * profilo.A * (hc + profilo.h/2);
    
    S_tot = S_cls + S_acc;
    
    A_tot = A_cls + n * profilo.A;
    
    yn = S_tot/A_tot;
    err = (yn-yn0)^2;
    yn0 = yn;
end

end

