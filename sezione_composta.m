classdef sezione_composta
    %SEZIONE_COMPOSTA Sezione composta acciaio (trave) - cls (soletta)
    %
    
    properties (SetAccess = protected)
        soletta     % sezione di cls efficace (oggetto di tipo sezione)
        soletta_el   % sezione di cls reagente (in compressione)
        soletta_pl
        profilo     % profilo di acciaio (tabella)
        hc          % altezza lorda della soletta (estradosso trave - estradosso soletta cls)
        n           % coefficiente di omogeneizzazione
        yn_el          % baricentro della sezione elastica
        yn_pl          % baricentro della sezione plastica
        Jid         % Momento di inerzia sezione composta (rispetto al cls)
        Rj          % rapporto momento di inerzia sezione composta rispetto alla sezione in acciaio
        materiale   % caratteristiche del materiale
        Mpl         % momento plastico della sezione composta
        Fc          % Forza della soletta ( da riprendere con i pioli)
    end
    
    methods
        function obj = sezione_composta(profilo, soletta, hc, n, mat_pro, mat_sol)
            % default
            if nargin < 4
                obj.n = 15;
            else
                obj.n = n;
            end
            
            if nargin < 5
                obj.materiale.profilo = struct('Es', 210000, 'fyk', 275, 'gamma_s', 1.05);
            else
                obj.materiale.profilo = mat_pro;
            end
            
            if nargin < 6
                obj.materiale.soletta = derivaCaratteristicheCA(25);
            else
                obj.materiale.soletta = mat_sol;
            end
            
            obj.profilo = profilo;
            obj.soletta = soletta;
            obj.hc = hc;
            [obj.yn_el, obj.Jid, obj.Rj, obj.soletta_el] = propSezioneComposta(obj.profilo, obj.soletta, obj.n, obj.hc);
            [obj.Mpl, obj.Fc, obj.yn_pl, obj.soletta_pl] = momentoResitenteSezComp(obj.profilo, obj.soletta, obj.hc, obj.materiale);
        end
        
        
    end
    
end

