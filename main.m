%% Dati Iniziali
% dati trave
q = 2.31+1.48+5;    % [kN/m2] carico applicato (condizioni SLE)
luce = 5.04; % [m] luce libera di inflessione
momento = @(q,l) q*l^2/8;   % funzione di calcolo del momento in mezzeria per trave app-app

% dati soletta
h_c = 120;  % [mm] altezza della soletta in cls+lamiera
h_lam = 55; % [mm] altezza della lamiera

% dati del materiale
cls = derivaCaratteristicheCA(25);
steel = derivaCaratteristicheAcciaio;

n = 15; % coefficiente di omogeneizzazione acciaio/cls

% database profili
workbookFile = 'Profili.xls';
profili = {'HEA','HEB','IPE'};  % selezione dei profili da utilizzare per il calcolo

