function [Loki] = GetLoki(Loki_input,reactions)

Loki_input = char(Loki_input);
if isempty(Loki_input)
    Loki = [];
else
% Loki_input is provided --------------------------------------------------
    present_directory = pwd;
    cd(GetPath("loki")) % Go to LoKI path

    if ~isfolder("Output/"+Loki_input)
        lokibcl([Loki_input,'.in']); % Run if there is not already a saving
    end
    
    Loki = ReadLokiHdf5(Loki_input+"/"+Loki_input); % read .hdf5

    eq = cellfun(@(x)char(x),reactions(:,1),'UniformOutput',false);
    k_input = cellfun(@(x)char(x),reactions(:,2),'UniformOutput',false);
    
    % find entries in electronKinetics.rateCoeffAll that match Loki tags in reactions
    map_MKin_Loki = zeros(numel(eq),2); % map between reactions in MatlabKin and Loki
    ii_Loki = find(contains(k_input,'->'));
    
    for i = ii_Loki'
        k = i;
        i_Loki = find(strcmpi(Loki.collDescription,Trim(k_input{i})));
        if isempty(i_Loki)
            error('Loki tag for reaction %s is not recognized!',eq{i})
        end
        ii = find(Loki.colldescr2rate(:,1)==i_Loki);
        if isscalar(ii)
            map_MKin_Loki(k,:) = [k,Loki.colldescr2rate(ii,2)];
        elseif length(ii) == 2 % map inverse rate, which follows the forward one
            map_MKin_Loki(k,:) = [k,Loki.colldescr2rate(ii(1),2)];
            k = k+1;
            map_MKin_Loki(k,:) = [k,Loki.colldescr2rate(ii(2),2)];
        end
    end
    
    map_MKin_Loki( ~any(map_MKin_Loki,2), : ) = []; % trim map
    if numel(map_MKin_Loki(:,2))~=numel(unique(map_MKin_Loki(:,2)))
       error('check for duplicates in reaction Loki tags!')
    end
    
    Loki.map_MKin_Loki = map_MKin_Loki;
    
    cd(present_directory)
end

end

function [string_out] = Trim(string_in)
    string_out = strrep(string_in, "    ","");
    string_out = strrep(string_out,"   ","");
    string_out = strrep(string_out,"  ","");
    string_out = strrep(string_out," ","");
end