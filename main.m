clear all
clc
%% Dati Iniziali
% dati trave
trave.carichi.PPp = 1.48;
trave.carichi.Qk = 0.7*4;
trave.coef.SLU.PP = 1.3;
trave.coef.SLU.PPp = 1.5;
trave.coef.SLU.Qk = 1.5;
trave.coef.SLE.PP = 1;
trave.coef.SLE.PPp = 1;
trave.coef.SLE.Qk = 1;

trave.luce = 5.04; % [m] luce libera di inflessione
trave.M = @(q,l) q*l^2/8;   % funzione di calcolo del momento in mezzeria per trave app-app
trave.freccia = @(q,l,E,J) 5/384*q*(l*10^3)^4/(E*J); % [mm] converto la luce in mm
trave.f_lim = trave.luce*1000/680;

% interassi di calcolo
interassi = 2.4:.2:2.8;   % [m] interassi di calcolo

% dati soletta
trave.hc = 110;  % [mm] altezza della soletta in cls+lamiera
h_lam = 55; % [mm] altezza della lamiera
lamcls = lam_cls(trave.hc,h_lam, 61.5, 61.5, 150, 0, 0, 0, 0); 
trave.carichi.PP = lamcls.peso;

% dati del materiale
mat_cls = derivaCaratteristicheCA(25);   % [MPa] resistenza cilindrica caretteristica del cls (da cui derivare le altre proprietà)
mat_acc = struct('fyk', 275, 'ftk', 430, 'Es', 210000, 'gamma_s', 1.05);

n = 15; % coefficiente di omogeneizzazione acciaio/cls

% database profili
workbookFile = 'Profili.xls';
profili_ammissibili = {'HEA','HEB','IPE'};  % selezione dei profili da utilizzare per il calcolo

%% main
% creazione della soletta
b_eff = trave.luce*1000/8 * 2;
soletta = sezione(b_eff, trave.hc-h_lam);

%
index_comb = cell(1,2); % indice delle combinazioni per interassi e profili_ammissibili
size_comb = [length(interassi) , length(profili_ammissibili)];
comb_tot = length(interassi) * length(profili_ammissibili);
ris = struct('Interasse', [], 'Profilo', [], 'Peso', [], 'P_sup', [], 'Efficienza', [],'yn_el', [], 'yn_pl', [], 'Rj', [], 'fa', [], 'fid', [], 'Frequenza', [], 'Rf', [], 'Med', [], 'Mpl', [], 'Rm', []);
ris = repmat(ris, comb_tot,1);
for i_main = 1:comb_tot
    [index_comb{:}] = ind2sub(size_comb, i_main);
    trave.interasse = interassi(index_comb{1});
    profili = conversione_mm(importProfili(workbookFile, profili_ammissibili{index_comb{2}}));
    [f_id, Rf, sc, Rm, Med] = verificaSezComp(profili, soletta, trave);
    ris(i_main).Interasse = trave.interasse;
    ris(i_main).Profilo = sc.profilo.designation;
    ris(i_main).Peso = sc.profilo.g;
    ris(i_main).yn_el = sc.yn_el;
    ris(i_main).yn_pl = sc.yn_pl;
    ris(i_main).Rj = sc.Rj;
    ris(i_main).fa = f_id*sc.Rj;
    ris(i_main).fid = f_id;
    ris(i_main).Rf = Rf;
    ris(i_main).P_sup = sc.profilo.g/trave.interasse;
    ris(i_main).Med = Med;
    ris(i_main).Mpl = sc.Mpl;
    ris(i_main).Rm = Rm;
end

ris = struct2table(ris);
%%
soluzione_ottimale = min(ris.P_sup);
efficienza = ris.P_sup/soluzione_ottimale;
frequenza = 18./(ris.fid).^0.5;
ris.Frequenza = frequenza;
ris.Efficienza = efficienza
    
    


