function [Loki] = ReadLokiHdf5(path)
Loki.E = h5read("Output/"+path+".h5", "/electronKinetics/reducedField")';
Loki.swarmParam = h5read("Output/"+path+".h5", "/electronKinetics/swarmParameters");
rates = h5read("Output/"+path+".h5", "/electronKinetics/rateCoefficients");
Loki.ratecoeff = reshape(reshape([reshape(rates.ine_coeff,[],1),reshape(rates.sup_coeff,[],1)]',[],1),[],numel(Loki.E))';

Loki.collDescription = rates.description(:,:,end)';
contains_double_arrow = contains(Loki.collDescription,'<->'); % find indexes of two-ways reactions

Loki.ratecoeff(:,2*find(~contains_double_arrow)) = [];
Loki.n_ratecoeff = size(Loki.ratecoeff, 2);

% create map from Loki collDescription to corresponding columns of Loki.ratecoeff
Loki.colldescr2rate = zeros(Loki.n_ratecoeff,2);
i_rate = 0;
for i=1:length(Loki.collDescription)
    i_rate = i_rate + 1;
    Loki.colldescr2rate(i_rate,:) = [i,i_rate];
    if contains_double_arrow(i)
        i_rate = i_rate + 1;
        Loki.colldescr2rate(i_rate,:) = [i,i_rate];
    end
end

end