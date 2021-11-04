# Custom controls for the A-6

# PHD's TC range switch (hard coded range in nautical miles)
# ----------------------------------------------------------
var PHD_TCrange_sw = func {
	var prop = props.globals.getNode(arg[0], 1);
	var pr = prop.getValue();
	var target = props.globals.getNode("/sim/model/A-6E/instrumentation/PHD/TCrange", 1);
	if (arg[1] == 1) {
		if (pr == 0) {
			prop.setDoubleValue(1);
			target.setDoubleValue(5);
		} elsif (pr == 1) {
			prop.setDoubleValue(2);
			target.setDoubleValue(1.5);
		}
	} else {
		if (pr == 1) {
			prop.setDoubleValue(0);
			target.setDoubleValue(10);
		} elsif (pr == 2) {
			prop.setDoubleValue(1);
			target.setDoubleValue(5);
		}
	}
}


# A-6 spoilers can be full open or closed:
# ----------------------------------------
var SpeedBrake = props.globals.getNode("controls/flight/speedbrake", 1);

setlistener( "controls/flight/spoilers/", func(v){
             SpeedBrake.setValue(v.getValue());
             print("speedbrake set to ",SpeedBrake.getValue());
}, 1, 0);

# Canopy switch animation and canopy move
# ---------------------------------------
# Toggle keystroke and 2 positions switch.
var cnpy = aircraft.door.new("canopy", 7);
var cswitch = props.globals.getNode("sim/model/A-6E/controls/canopy/canopy-switch", 1);
var pos = props.globals.getNode("canopy/position-norm", 1);

var canopyswitch = func(v) {
	var p = pos.getValue();
	if (v == 2 ) {
		if ( p < 1 ) {
			v = 1;
		} elsif ( p >= 1 ) {
			v = -1;
		}
	}
	if (v < 0) {
		cswitch.setIntValue(1);
		cnpy.close();

	} elsif (v > 0) {
		cswitch.setIntValue(-1);
		cnpy.open();

	}
}


# Landing gear handle animation 
# -----------------------------
setlistener( "controls/gear/gear-down", func { ldg_hdl_main(); } );

var ld_hdl = props.globals.getNode("sim/model/A-6E/controls/gear/ld-gear-handle-anim", 1);

var ldg_hdl_main = func {
	var pos = ld_hdl.getValue();
	if ( getprop("controls/gear/gear-down") == 1 ) {
		if ( pos > -1 ) {
			ldg_hdl_anim(-1, pos);
		}
	} elsif ( pos < 0 ) {
		ldg_hdl_anim(1, pos);
	}
}

var ldg_hdl_anim = func {
	var incr = arg[0]/10;
	var pos = arg[1] + incr;

	if ( ( arg[0] = 1 ) and ( pos >= 0 ) ) {    
		ld_hdl.setDoubleValue(0);
	} elsif ( ( arg[0] = -1 ) and ( pos <= -1 ) ) {
		ld_hdl.setDoubleValue(-1);
	} else {
		ld_hdl.setDoubleValue(pos);
		settimer( ldg_hdl_main, 0.05 );
	}
}

ldg_hdl_main();

# General 3 positions switch (2 - 1 - 0)
# --------------------------------------
var three_pos_sw = func {
	var prop = props.globals.getNode(arg[0], 1);
	var pr = prop.getValue();
	if (arg[1] == 1) {
		if (pr == 0) {
			prop.setDoubleValue(1);
		} elsif (pr == 1) {
			prop.setDoubleValue(2);
		}
	} else {
		if (pr == 1) {
			prop.setDoubleValue(0);
		} elsif (pr == 2) {
			prop.setDoubleValue(1);
		}
	}
}


# General 3 positions switch variant (2 - 0 - 1)
# ----------------------------------------------
var three_pos_sw_b = func {
	var prop = props.globals.getNode(arg[0], 1);
	var pr = prop.getValue();
	if (arg[1] == 1) {
		if (pr == 0) {
			prop.setDoubleValue(2);
		} elsif (pr == 1) {
			prop.setDoubleValue(0);
		}
	} else {
		if (pr == 2) {
			prop.setDoubleValue(0);
		} elsif (pr == 0) {
			prop.setDoubleValue(1);
		}
	}
}


# Flood light 3 positions switch variant (1 - 0.5 - 0.25)
# -------------------------------------------------------
var three_pos_sw_flood = func {
	var prop = props.globals.getNode(arg[0], 1);
	var pr = prop.getValue();
	if (arg[1] == 1) {
		if (pr == 0.25) {
			prop.setDoubleValue(0.5);
		} elsif (pr == 0.5) {
			prop.setDoubleValue(1);
		}
	} else {
		if (pr == 1) {
			prop.setDoubleValue(0.5);
		} elsif (pr == 0.5) {
			prop.setDoubleValue(0.25);
		}
	}
}


# Old Fashioned Radio Button Selector
# -----------------------------------
# Where group is the parent node that contains the radio state nodes as children.

var radio_bt_sel = func(group, which) {
	foreach (var n; props.globals.getNode(group).getChildren()) {
		n.setBoolValue(n.getName() == which);
	}
}


# TACAN XY switch
# ---------------

var TcXYSwitch       = props.globals.getNode("sim/model/A-6E/controls/instrumentation/tacan/xy-switch", 1);

var tacan_switch_init = func {
	if (A6E.TcXY.getValue() == "X") { TcXYSwitch.setValue( 0 ) } else { TcXYSwitch.setValue( 1 ) }
}

var tacan_XYtoggle = func {
	if ( A6E.TcXY.getValue() == "X" ) {
		A6E.TcXY.setValue( "Y" );
		TcXYSwitch.setValue( 1 );
	} else {
		A6E.TcXY.setValue( "X" );
		TcXYSwitch.setValue( 0 );
	}
}



# AFCS (Auto Flight Control System) Panel
# ---------------------------------------
var alt_button = props.globals.getNode("sim/model/A-6E/controls/autopilot/alt-button");
var mach_button = props.globals.getNode("sim/model/A-6E/controls/autopilot/mach-button");
var cmd_switch = props.globals.getNode("sim/model/A-6E/controls/autopilot/cmd-switch");
var afcs_auto = props.globals.getNode("sim/model/A-6E/controls/autopilot/auto-stab-augm-switch");
var afcs_on_off = props.globals.getNode("sim/model/A-6E/controls/autopilot/on-off-switch");
var vdi_alt_marker = props.globals.getNode("sim/model/A-6E/controls/autopilot/vdi-alt-marker");
var vdi_hdg_marker = props.globals.getNode("sim/model/A-6E/controls/autopilot/vdi-roll-marker");
var press_alt_ft = props.globals.getNode("instrumentation/altimeter/pressure-alt-ft");
var alt_ref = props.globals.getNode("autopilot/settings/target-altitude-ft");
var ap_alt_lock = props.globals.getNode("autopilot/locks/altitude");
var ap_hdg_lock = props.globals.getNode("autopilot/locks/heading");
var roll_deg = props.globals.getNode("orientation/roll-deg");
var target_roll_deg = props.globals.getNode("autopilot/internal/target-roll-deg");

var afcs_power = func() {
	var on = afcs_on_off.getBoolValue();
	if ( ! on ){
		afcs_on_off.setBoolValue( 1 );
	} else {
		afcs_on_off.setBoolValue( 0 );
		afcs_auto.setBoolValue( 0 );
		afcs_disengage();
	}
}

var afcs_alt = func {
	var alt = alt_button.getValue();
	var engage = afcs_auto.getValue();
	if ( alt ){
		alt_button.setBoolValue( 0 );
		afcs_auto.setBoolValue( 0 );
		if ( engage ) {
			afcs_disengage();
		}
	} else {
		alt_button.setBoolValue( 1 );
		mach_button.setBoolValue( 0 );
		if ( engage ) {
			afcs_engage();
		}
	}
}

var afcs_mach = func {
	var mach = mach_button.getValue();
	var engage = afcs_auto.getValue();
	if ( mach ){
		mach_button.setBoolValue( 0 );
	} else {
		mach_button.setBoolValue( 1 );
		alt_button.setBoolValue( 0 );
		ap_alt_lock.setValue("");
		vdi_alt_marker.setBoolValue( 0 );
		if ( engage ) {
			afcs_disengage();
		}
	}
}

var afcs_cmd = func() {
	var engage = afcs_auto.getValue();
	var on = cmd_switch.getBoolValue();
	if ( ! on ) {
		cmd_switch.setBoolValue( 1 );
		if ( engage ) {
			afcs_engage();
		}
	} else {
		cmd_switch.setBoolValue( 0 );
		ap_hdg_lock.setValue("");
		vdi_hdg_marker.setBoolValue( 0 );
	}
}

var afcs_engage_toggle = func() {
	var on = afcs_auto.getBoolValue();
	if ( ! on ){
		afcs_engage();
	} else {
		afcs_disengage();
	}
}

var afcs_engage = func() {
	var power = afcs_on_off.getValue();
	afcs_auto.setBoolValue(1);
	var alt = alt_button.getValue();
	var hdg = cmd_switch.getValue();
	if (power) {
		if ( alt ) {
			alt_ref.setValue(press_alt_ft.getValue());
			ap_alt_lock.setValue("altitude-hold");
			vdi_alt_marker.setBoolValue(1);
		}
		if ( hdg ) {
			rdeg = roll_deg.getValue();
			if ((rdeg < -5) or (rdeg > 5)) {
				if (rdeg < -60) {
					rdeg = -60;
				}
				if (rdeg > 60) {
					rdeg = 60;
				}
				target_roll_deg.setValue( rdeg );
				ap_hdg_lock.setValue("roll-hold");
			} else {
				ap_hdg_lock.setValue("wing-leveler");
			}
			vdi_hdg_marker.setBoolValue(1);
		}
	} else {
		settimer(func { afcs_disengage() }, 0.1);
	}
}

var afcs_disengage = func() {
	afcs_auto.setBoolValue(0);
	alt_ref.setValue(0);
	ap_alt_lock.setValue("");
	vdi_alt_marker.setBoolValue(0);
	ap_hdg_lock.setValue("");
	target_roll_deg.setValue(0);
	vdi_hdg_marker.setBoolValue(0);
}


# collision lights flasher
# ------------------------
var beacon = props.globals.getNode("controls/lighting/beacon", 1);
aircraft.light.new("sim/model/A-6E/lighting/beacon_state", [0.08, 1.20], beacon);

# warning lights medium speed flasher
# -----------------------------------
aircraft.light.new("sim/model/A-6E/lighting/warn-medium-lights-switch", [0.4, 0.3]);
setprop("sim/model/A-6E/lighting/warn-medium-lights-switch/enabled", 1);

# warning lights fast speed flasher
# -----------------------------------
aircraft.light.new("sim/model/A-6E/lighting/warn-fast-lights-switch", [0.1, 0.1]);
setprop("sim/model/A-6E/lighting/warn-fast-lights-switch/enabled", 1);


# launchbar activation

var launchbar_toggle = func {
    
    # prevent holdback when in the air.
    if(getprop("fdm/jsbsim/position/aircraft-on-ground"))
    {
	if (getprop("fdm/jsbsim/systems/holdback/holdback-cmd"))
	{
	    print("Disengage launchbar");
	    setprop("fdm/jsbsim/systems/catapult/cat-launch-cmd",0);
	    setprop("fdm/jsbsim/systems/holdback/holdback-cmd",0);
	    setprop("/controls/gear/brake-parking",1);
	}
	else
	{
	    print("Engage launchbar");
	    setprop("fdm/jsbsim/systems/catapult/cat-launch-cmd",0);
	    setprop("fdm/jsbsim/systems/holdback/holdback-cmd",1);
	    setprop("/controls/gear/brake-parking",0);
	}
    }
    else
    {
	setprop("fdm/jsbsim/systems/catapult/cat-launch-cmd",0);
	setprop("fdm/jsbsim/systems/holdback/holdback-cmd",0);
    }
}

# launch catapult
var catapult = func {
    if (getprop("fdm/jsbsim/systems/holdback/holdback-cmd"))
    {
	print("Catapult launch");
	setprop("fdm/jsbsim/systems/catapult/cat-launch-cmd",1);
	setprop("fdm/jsbsim/systems/holdback/holdback-cmd",0);
        settimer(func{
	    setprop("fdm/jsbsim/systems/catapult/cat-launch-cmd",0);},
	    1 / getprop("fdm/jsbsim/systems/catapult/launch-rate"));
    }
    else
    {
    }
}
