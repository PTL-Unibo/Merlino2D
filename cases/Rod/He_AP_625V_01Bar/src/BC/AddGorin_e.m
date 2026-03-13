function [Bcflag_mod] = AddGorin_e(Bcflag)
Bcflag_mod = Bcflag;
for i = 1:size(Bcflag,1)
    if Bcflag(i,1) == "GorinLike"
        Bcflag_mod(i,1) = "GorinLike_electrons";
    end
end
end