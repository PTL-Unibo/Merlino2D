function [Get_nL,Get_nR] = CreateMultiUpwind(msh,ns)

indices_upwind = setdiff((1:msh.Nf)',[msh.f_from_b;msh.f_from_d]);
indices_n_left = msh.cs_from_f(indices_upwind,1);
indices_n_right = msh.cs_from_f(indices_upwind,2);

indices_upwind_multi = reshape(indices_upwind.*ones(1,ns) + (0:msh.Nf:(ns-1)*msh.Nf),[],1);
indices_n_left_multi = reshape(indices_n_left.*ones(1,ns) + (0:msh.Nc:(ns-1)*msh.Nc),[],1);
indices_n_right_multi = reshape(indices_n_right.*ones(1,ns) + (0:msh.Nc:(ns-1)*msh.Nc),[],1);

Get_nL = sparse(indices_upwind_multi,indices_n_left_multi,1,msh.Nf*ns,msh.Nc*ns);
Get_nR = sparse(indices_upwind_multi,indices_n_right_multi,1,msh.Nf*ns,msh.Nc*ns);

end
