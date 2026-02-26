function [p] = M2DInput(opts,extra)

arguments
    opts (1,1) struct
    extra.MSH
    extra.MSH_PARAMETERS
    extra.EPSR_VAL
    extra.BCEL_FLAG
    extra.BCEL_VAL
    extra.V_APPLIED
    extra.DV_APPLIED
    extra.BC_FLAG
    extra.BC_VAL
    extra.TIME_INSTANTS
    extra.INITIAL_CONDITION
    extra.MU
    extra.D
    extra.V_TH_COEFF
    extra.CONST_OMEGA
    extra.PHOTOIONIZATION
    extra.CHEMICAL_MODEL
    extra.CONST_SPECIES
    extra.LOKI_INPUT
    extra.ELECTRON_TEMPERATURE
    extra.TEMPERATURE
    extra.PRESSURE
    extra.ELECTRON_REF_COEFF
    extra.GAMMA_II
    extra.SURF_CHARGE_COEFF
    extra.GAMMA_II_DIEL
    extra.SAVE_EACH_K_TIMESTEPS
    extra.COORDINATES (1,:) char {mustBeMember(extra.COORDINATES,{'cartesian','cylindrical'})}
    extra.ODE_TYPE (1,:) char {mustBeMember(extra.ODE_TYPE,{'ode15s','idas'})}
    extra.OPEN_GMSH (1,1) double {mustBeMember(extra.OPEN_GMSH,[0,1])}
    extra.REORDERING (1,1) double {mustBeMember(extra.REORDERING,[0,1])}
    extra.OUTPUT_FUNCTION (1,:) char {mustBeMember(extra.OUTPUT_FUNCTION,{'bar','cmd','none'})}
    extra.BAR_SCALE (1,:) char {mustBeMember(extra.BAR_SCALE,{'lin','log'})}
    extra.STEADY_STATE_THRESHOLD
    extra.T_START_STEADY_STATE
    extra.ABS_TOL
    extra.REL_TOL
    extra.SPECIES_NO_CHEM
    extra.ELECTRIC_FIELD_0D
end

% setting all parameters to default values
p = DefaultMerlino2Dinput(); 
number_of_parameters = numel(fieldnames(p));

% replacing default parameters with the one specified in input structure
for name = fieldnames(opts)'
    p.(name{1}) = opts.(name{1});
end
if numel(fieldnames(p)) ~= number_of_parameters
    error("The name of one of the input parameters is invalid")
end

% if extra parameters have been provided, replace with them
for name = fieldnames(extra)'
    p.(name{1}) = extra.(name{1});
end

end