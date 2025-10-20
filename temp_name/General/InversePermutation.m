function [inv_ppp] = InversePermutation(ppp)
    dim = numel(ppp);
    aux_inv_ppp = [ppp(:), (1:dim)'];
    aux_inv_ppp = sortrows(aux_inv_ppp);
    inv_ppp = aux_inv_ppp(:,2);
end
