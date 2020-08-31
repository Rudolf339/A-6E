# setprop("/fdm/jsbsim/systems/instrument/fuel/tank-select", int(rand() * 7));
# TODO: re-enable once 3d controls are available
var damageRate = 1 / (180 + int((rand() - 0.5) * 120));
setprop("/fdm/jsbsim/systems/instrument/fuel/damage-rate", damageRate);
