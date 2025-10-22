function [fComputeMu,fComputeD,fComputeKr] = GetFcomputeMuDKr(Mu,D,Kr,Nc,Nf,Loki,inverse_mapping)

flag_loki = 0;
if ~isempty(Loki)
    Loki_D = griddedInterpolant(Loki.E,cell2mat({Loki.swarmParam.redDiffCoeff}),'pchip','nearest'); %#ok<NASGU> % reduced diffusion coefficient
    Loki_mu = griddedInterpolant(Loki.E,cell2mat({Loki.swarmParam.redMobility}),'pchip','nearest'); %#ok<NASGU> % reduced mobility
    Loki_alpha = griddedInterpolant(Loki.E,cell2mat({Loki.swarmParam.redTownsendCoeff}),'pchip','nearest'); %#ok<NASGU> % reduced Townsend ionization coefficient
    Loki_eta = griddedInterpolant(Loki.E,cell2mat({Loki.swarmParam.redAttCoeff}),'pchip','nearest'); %#ok<NASGU> % reduced attachment coefficient
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

strMu = "@(E,Te,T,Ngas)[" + join(Mu_str,",") + "]";
strD = "@(mu,E,Te,T,Ngas)[" + join(D_str,",") + "]";
if flag_loki == 1
    strKr = "@(Loki_k,E,Te,T,Ngas)[" + join(Kr_str,",") + "]";
else
    strKr = "@(E,Te,T,Ngas)[" + join(Kr_str,",") + "]";
end

strMu = AddDot(strMu);
strD = AddDot(strD);
for i = 1:numel(inverse_mapping)
    strD = strrep(strD,"mu"+i,"muxx"+inverse_mapping(i));
end
strD = regexprep(strD, 'muxx(\d+)', 'mu(:,$1)'); % replace mu123 with mu(:,123)
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
