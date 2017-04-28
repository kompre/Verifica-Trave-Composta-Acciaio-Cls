function [ f_id, Rf, sc, Rm, Med] = verificaSezComp( profili, soletta, trave )
%VERIFICAFRECCIA Summary of this function goes here
%   Detailed explanation goes here

stato_limite = {'SLU', 'SLE'};
casi_carico = fieldnames(trave.carichi);
for h = 1:height(profili)
    pro = profili(h, :);    % estrazione del profilo h-esimo
    sc = sezione_composta(pro, soletta, trave.hc);  % creazione sezione composta
    % calcolo di q tenendo conto del peso del profilo
    for l = 1:length(stato_limite)
        q.(stato_limite{l}) = sc.profilo.g/100 * trave.coef.(stato_limite{l}).PP;  % inizializzo con il peso proprio della trave nello stato limite opportuno
        for c = 1:length(casi_carico)
            q.(stato_limite{l}) = q.(stato_limite{l}) + trave.carichi.(casi_carico{c}) * trave.coef.(stato_limite{l}).(casi_carico{c}) * trave.interasse;
        end
    end
    % calcolo della freccia
    fa = trave.freccia(q.SLE, trave.luce, sc.materiale.profilo.Es, sc.profilo.Iy);   % freccia elastica rispetto alla sola sezione di acciaio
    f_id = fa/sc.Rj;    % freccia della sezione composta
    Rf = f_id/trave.f_lim;  % rapporto freccia sezione composta/freccia limite
    
    % Calcolo del momento flettente
    Med = trave.M(q.SLU, trave.luce);  % [kN/m] momento sollecitante
    Rm = Med/sc.Mpl;    % rapporto tra momento sollecitante e momento resistente
    if Rf <= 1 && Rm <=1
        break
    end
end



end

