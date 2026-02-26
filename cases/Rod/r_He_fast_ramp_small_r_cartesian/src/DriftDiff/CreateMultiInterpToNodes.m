function [A,B] = CreateMultiInterpToNodes(msh, indices, ns)

indices_non_bnodes = setdiff((1:msh.Nn)', msh.n_from_bn);

b_from_f = zeros(msh.Nf,1);
b_from_f(msh.f_from_b) = 1:msh.Nb;

I_A_FINAL = [];
J_A_FINAL = [];
S_A_FINAL = [];

I_B_FINAL = [];
J_B_FINAL = [];
S_B_FINAL = [];

for k = 1:ns
    I_A = [];
    J_A = [];

    I_B = [];
    J_B = [];

    % Inner / Flux Flux
    ii = [indices_non_bnodes; msh.n_from_bn(indices{k}.bnodes.id11)];
    I_A = [I_A; reshape(repelem(ii, msh.num_cs_from_n(ii)),[],1)]; % the reshape instruction assures that we have a column vector
    J_A = [J_A; vertcat(msh.cs_from_n{ii})];
    S_A_FINAL = [S_A_FINAL; vertcat(msh.w_cs_from_n{ii})];

    % Dirichlet Dirichlet
    ii = indices{k}.bnodes.id00;
    I_B = [I_B; reshape(repelem(msh.n_from_bn(ii), 2),[],1)]; % the reshape instruction assures that we have a column vector
    J_B = [J_B; reshape(b_from_f(msh.fs_from_bn(ii,:))',[],1)]; 
    S_B_FINAL = [S_B_FINAL; 0.5 * ones(2*length(ii),1)];
    
    % Dirichlet Flux
    ii = indices{k}.bnodes.id01;
    I_B = [I_B; msh.n_from_bn(ii)]; 
    J_B = [J_B; b_from_f(msh.fs_from_bn(ii,1))]; 
    S_B_FINAL = [S_B_FINAL; ones(length(ii),1)];

    % Flux Dirichlet
    ii = indices{k}.bnodes.id10;
    I_B = [I_B; msh.n_from_bn(ii)]; 
    J_B = [J_B; b_from_f(msh.fs_from_bn(ii,2))]; 
    S_B_FINAL = [S_B_FINAL; ones(length(ii),1)];

    I_A = I_A + (k-1)*msh.Nn;
    J_A = J_A + (k-1)*msh.Nc;
    I_B = I_B + (k-1)*msh.Nn;
    J_B = J_B + (k-1)*msh.Nb;

    I_A_FINAL = [I_A_FINAL; I_A];
    J_A_FINAL = [J_A_FINAL; J_A];
    
    I_B_FINAL = [I_B_FINAL; I_B];
    J_B_FINAL = [J_B_FINAL; J_B];
end

A = sparse(I_A_FINAL, J_A_FINAL, S_A_FINAL, ns*msh.Nn, ns*msh.Nc);
B = sparse(I_B_FINAL, J_B_FINAL, S_B_FINAL, ns*msh.Nn, ns*msh.Nb);

end
