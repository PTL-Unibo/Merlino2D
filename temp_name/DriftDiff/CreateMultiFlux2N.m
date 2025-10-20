function [Flux2N] = CreateMultiFlux2N(msh, ns)

ii = repmat((1:msh.Nc)',3,1);
jj = msh.fs_from_c(:);
ss = msh.snsign(:) .* msh.areaf(jj);

II = reshape(repmat(ii,1,ns)+(0:msh.Nc:(ns-1)*msh.Nc), [], 1);
JJ = reshape(repmat(jj,1,ns)+(0:msh.Nf:(ns-1)*msh.Nf), [], 1);
SS = reshape(repmat(ss,1,ns),[],1);

Flux2N = sparse(II, JJ, SS, ns*msh.Nc, ns*msh.Nf);
Flux2N = Flux2N .* repmat(msh.inv_vol,ns,1);

end
