function [ yn, J_id, Rj, soletta] = propSezioneComposta( profilo, soletta, n, hc, precisione)
%BARICENTROSEZIONECOMPOSTA calcolo del baricentro della sezione composta
% il baricentro della sezione è calcolato con origine all'estradosso
% superiore. Si considera la sezine completamente reagente.

%% dati di primo tentativo
if nargin < 5
    precisione = .001;
end
yn0 = hc;
err = 1;

%% calcolo baricentro
while err > precisione
    if yn0 > soletta.h
        h_calc = soletta.h;
    else
        h_calc = yn0;
    end
    % contributo cls
    S_cls = soletta.b * h_calc^2/2;
    A_cls = soletta.b * h_calc;
    
    % contributo acciaio
    S_acc = n * profilo.A * (hc + profilo.h/2);
    
    S_tot = S_cls + S_acc;
    
    A_tot = A_cls + n * profilo.A;
    
    yn = S_tot/A_tot;
    err = (yn-yn0)^2;
    yn0 = yn;
end

%% calcolo Inerzia Sezione Composta
if yn < soletta.h
    soletta = sezione(soletta.b, yn);
end

% contributo cls
J_cls = soletta.Jy + soletta.area_sezione * (soletta.y0 - yn)^2;

% contributo acciaio
J_acc = n*(profilo.Iy + profilo.A * (hc + profilo.h/2 - yn)^2);

% somma dei contributi
J_id = J_cls + J_acc;   % momento di inerzia totale della sezione composta
Rj = J_id/(n * profilo.Iy); % rapporto momento di inerzia sezione composta rispetto al momento di inerzia del solo profilo in acciaio


end

