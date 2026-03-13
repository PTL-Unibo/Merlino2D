function [] = InitializePhoto(y,t,p,ph_is_on)
global Sph %#ok<GVMIS>
if ph_is_on
    UpdatePhoto(y,t,p);
else
    Sph = 0;
end
end