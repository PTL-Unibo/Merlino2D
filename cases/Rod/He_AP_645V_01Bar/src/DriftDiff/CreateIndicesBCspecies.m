function [indices] = CreateIndicesBCspecies(msh, BCflag, ns)
% each column of BCflag corresponds to a species
% the row number corresponds to the bID

indices = cell(ns,1);

for k = 1:ns
    indices{k} = struct;
    indices{k}.bnodes = struct;
    indices{k}.faces = struct;

    logical_matrix_Dirichlet = ~ismember(msh.bIDs_from_bn,find(BCflag(:,k) == "Dirichlet"));
    base_10_nums = sum(logical_matrix_Dirichlet.*[2,1],2); % convert from binary to base 10
    indices{k}.bnodes.id00 = find(base_10_nums==0);
    indices{k}.bnodes.id01 = find(base_10_nums==1);
    indices{k}.bnodes.id10 = find(base_10_nums==2);
    indices{k}.bnodes.id11 = find(base_10_nums==3);
    
    indices{k}.faces.D = msh.f_from_b(vertcat(msh.bs_from_bID{BCflag(:,k) == "Dirichlet"}));
    indices{k}.faces.F = msh.f_from_b(vertcat(msh.bs_from_bID{BCflag(:,k) == "Flux"}));
end

end
