function [ Mpl, Fc, yn_pl, soletta_pl] = momentoResitenteSezComp( profilo, soletta, hc, materiale, precisione)
%MOMENTORESITENTESEZCOMP Calcolo del Momento resistente per la sezione
%   composta
%   ATTENZIONE! manca il caso in cui l'asse neutro taglia il profilo!

if nargin < 5
    precisione = .0001;
end

yn0 = 0;
err = 1;

while err > precisione
    if yn0 < soletta.h
        Fa = profilo.A * materiale.profilo.fyk/materiale.profilo.gamma_s;
        yn_pl = Fa / (soletta.b * materiale.soletta.f_cd);
        soletta_pl = sezione(soletta.b, yn_pl);
        Fc = soletta_pl.area_sezione * materiale.soletta.f_cd;
    else
        Fa = profilo.A * materiale.profilo.fyk/materiale.profilo.gamma_s;
        Fc = soletta.area_sezione * materiale.soletta.f_cd;
        yn_pl = (hc + profilo.h/2 + soletta.h/2)/2;
    end
    err = (yn0-yn_pl)^2;
    yn0 = yn_pl;
end

if yn_pl > hc
    warning('yn_pl taglia il profilo in acciaio\nCaso non previsto')
end
Mpl = Fa * (profilo.h/2 + hc - yn_pl) + Fc * (yn_pl - soletta_pl.h/2);
Mpl = Mpl*1e-6;  % [kN/m]
Fc = Fc*1e-3;    % [kN]



end

