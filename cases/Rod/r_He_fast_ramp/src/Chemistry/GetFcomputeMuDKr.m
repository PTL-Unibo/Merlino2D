function [fComputeMu,fComputeD,fComputeKr] = GetFcomputeMuDKr(Mu,D,Kr,Nc,Nf,Loki,species)

flag_loki = 0;
if ~isempty(Loki)
    Loki_D = griddedInterpolant(Loki.E,Loki.swarmParam.redDiffCoeff,'pchip','nearest'); %#ok<NASGU> % reduced diffusion coefficient
    Loki_mu = griddedInterpolant(Loki.E,Loki.swarmParam.redMobility,'pchip','nearest'); %#ok<NASGU> % reduced mobility
    Loki_alpha = griddedInterpolant(Loki.E,Loki.swarmParam.redTownsendCoeff,'pchip','nearest'); %#ok<NASGU> % reduced Townsend ionization coefficient
    Loki_eta = griddedInterpolant(Loki.E,Loki.swarmParam.redAttCoeff,'pchip','nearest'); %#ok<NASGU> % reduced attachment coefficient
    if numel(Loki.map_MKin_Loki) > 0 
        % only if some rates need to be evaluated with LoKI ---------------
        k_Loki = Loki.ratecoeff(:,Loki.map_MKin_Loki(:,2));
        Loki_k = griddedInterpolant(Loki.E,k_Loki,'pchip','nearest');
        flag_loki = 1;
        for i = 1:size(Loki.map_MKin_Loki,1)
            Kr{Loki.map_MKin_Loki(i,1)} = "Loki_k(:," + i + ")";
        end
    end
end

Mu_str = CellExpressionToStringArray(Mu,Nf);
D_str = CellExpressionToStringArray(D,Nf);
Kr_str = CellExpressionToStringArray(Kr,Nc);

if isfolder(GetPath("data")+"/"+"func")
    addpath(GetPath("data")+"/"+"func")
end

strMu = "@(E,Te,T,Ngas)[" + join(Mu_str,",") + "]";
strD = "@(mu,E,Te,T,Ngas)[" + join(D_str,",") + "]";
if flag_loki == 1
    strKr = "@(Loki_k,E,Te,T,Ngas)[" + join(Kr_str,",") + "]";
else
    strKr = "@(E,Te,T,Ngas)[" + join(Kr_str,",") + "]";
end

strMu = AddDot(strMu);
strD = AddDot(strD);
for i = 1:numel(species)
    strD = strrep(strD,"<<mu"+species(i)+">>","mu(:," + i + ")"); % replace, i.e., muO2+ with mu(:,7)
end
strKr = AddDot(strKr);

% creating griddedInterpolants --------------------------------------------
file_names_str = GetCSVfilesInData();
num_files = numel(file_names_str);
for i = 1:num_files
    if contains(strMu,file_names_str(i)) || contains(strD,file_names_str(i)) || contains(strKr,file_names_str(i))
        LUT = load(GetPath("data") + "/"+file_names_str(i)+".csv"); %#ok<NASGU>
        eval(file_names_str(i) + " = griddedInterpolant(LUT(:,1),LUT(:,2),""pchip"",""nearest"");");
    end
end
% -------------------------------------------------------------------------

fComputeMu = eval(strMu);
fComputeD = eval(strD);

if flag_loki == 1
    partial_fKr = eval(strKr);
    fComputeKr = @(E,Te,T,Ngas)partial_fKr(Loki_k(E),E,Te,T,Ngas);
else
    fComputeKr = eval(strKr);
end

end
