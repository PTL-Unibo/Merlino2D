function [dndt] = OdeFunc0D(t,n,fE,fTe,fKr,T,Ngas,M,Mindices,Nindices,stoichiometric_matrix,const_omega)

E_Td = fE(t);

Te = fTe(E_Td);

kr = fKr(E_Td,Te,T,Ngas);

M(1,:) = kr(:);

M(Mindices) = n(Nindices);

reaction_rates = prod(M);

omega = reaction_rates*stoichiometric_matrix + const_omega;

dndt = omega';

end