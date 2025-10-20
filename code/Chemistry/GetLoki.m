function [Loki] = GetLoki(Loki_input,save_file,reactions)

Loki_input = char(Loki_input);
if isempty(Loki_input)
    Loki = [];
else
% Loki_input is provided --------------------------------------------------
    % Go to LoKI path
    present_directory = pwd;
    cd(GetPath("loki"))
    
    if Loki_input(end-2:end) == ".in"
    
        [electronKinetics,Loki] = lokibcl(Loki_input);
        
        % get rate coeffients from Loki
        Loki.n_ratecoeff = length(cell2mat({Loki.ratecoeff_cell{1}.value})); % how many rates from Loki
        Loki.ratecoeff = zeros(length(Loki.E),Loki.n_ratecoeff);
        for i=1:length(Loki.E)
            t = cell2mat(Loki.ratecoeff_cell(i));
            Loki.ratecoeff(i,:) = cell2mat({t.value});
        end
        
        % find entries in electronKinetics.rateCoeffAll that match Loki tags in reactions
        Loki.collDescription = {electronKinetics.rateCoeffAll(:).collDescription};
        
        % create map from Loki collDescription to corresponding columns of Loki.ratecoeff
        Loki.colldescr2rate = zeros(Loki.n_ratecoeff,2);
        contains_double_arrow = contains(Loki.collDescription,'<->'); % find indexes of two-ways reactions
        i_rate = 0;
        for i=1:length(Loki.collDescription)
            i_rate = i_rate + 1;
            Loki.colldescr2rate(i_rate,:) = [i,i_rate];
            if contains_double_arrow(i)
                i_rate = i_rate + 1;
                Loki.colldescr2rate(i_rate,:) = [i,i_rate];
            end
        end
    
        % Save results
        save_file = char(save_file);
        if ~isempty(save_file)
            if ~exist("LoKIsavings", 'dir')
                mkdir("LoKIsavings");
            end
            save("LoKIsavings/"+save_file,"Loki");
        end
    % ---------------------------------------------------------------------    
    elseif Loki_input(end-3:end) == ".mat"
        load("LoKIsavings/"+Loki_input,'Loki');
    end
    
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