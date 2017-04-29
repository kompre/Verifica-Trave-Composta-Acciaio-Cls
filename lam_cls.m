classdef lam_cls
    %LAM_CLS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        h_tot
        h_lam
        h_c
        bf_sup
        bf_inf
        i
        bi_sup
        ni_sup
        bi_inf
        ni_inf
        area_i
        area
        peso
        rho = 25
    end
    
    methods
        function [obj] = lam_cls(h_tot, h_lam, bf_sup, bf_inf, i, ni_sup, bi_sup, ni_inf, bi_inf)
            obj.h_tot = h_tot;
            obj.h_lam = h_lam;
            obj.bf_sup = bf_sup;
            obj.bf_inf = bf_inf;
            obj.i = i;
            obj.ni_sup = ni_sup;
            obj.bi_sup = bi_sup;
            obj.ni_inf = ni_inf;
            obj.bi_inf = bi_inf;
            obj.h_c = h_tot - h_lam;
            obj = calcArea(obj);
            obj = calcPeso(obj);
        end
        
        function [obj] = calcArea(obj)
            obj.area_i = obj.h_c*obj.i + (obj.i - obj.bf_sup + obj.bf_inf) * obj.h_lam/2 + obj.ni_sup*(obj.bi_sup^2/4) - obj.ni_inf*(obj.bi_inf^2/4);
            obj.area = obj.area_i/(obj.i*1e-3);
        end
        
        function [obj] = calcPeso(obj)
            obj.peso = obj.area*1e-6 * obj.rho;
        end
            
    end
    
end

