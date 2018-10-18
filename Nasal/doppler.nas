# Simulates the A-6 Doppler Drift Indicator. 
# ------------------------------------------

# define operating charasteristics 
var min_alt_ft    = 40; # do not compute extreme altitudes because of system limitations.
var max_alt_ft    = 50000; 
var min_gs_kt     = 80; # do not compute extreme ground speeds because of system limitations.
var max_gs_kt     = 800;
var min_pitch_deg = -17; # system rejects doppler signal when pitch or roll values are too high.
var max_pitch_deg = 17;
var min_roll_deg  = -25;
var max_roll_deg  = 25;
var min_drift_deg = -25; # clamp drift indication due to antena limitations.
var max_drift_deg = 25;

var UPDATE_PERIOD = 0.3;

var sel_mode      = props.globals.getNode("/sim/model/A-6E/controls/instrumentation/doppler/mode-selector");
var ac_hdg        = props.globals.getNode("/orientation/heading-deg");
var pitch         = props.globals.getNode("/orientation/pitch-deg");
var roll          = props.globals.getNode("/orientation/roll-deg");
var groundspeed   = props.globals.getNode("/velocities/groundspeed-kt");
var altitude      = props.globals.getNode("/position/altitude-agl-ft");
var ac_hdg        = props.globals.getNode("/orientation/heading-deg"); 

var doppler_gs    = props.globals.getNode("/sim/model/A-6E/instrumentation/doppler/ground-speed-kt");
var doppler_dd    = props.globals.getNode("/sim/model/A-6E/instrumentation/doppler/drift-deg");
var doppler_mem   = props.globals.getNode("/sim/model/A-6E/instrumentation/doppler/memory");
var gs_tmp        = 0;


# main loop ####################
update_loop = func {
	var mode = sel_mode.getValue();
	if ( mode > 0 ) {
		if ( mode == 4 ) {
			# 4 = test mode
			doppler_gs.setDoubleValue( 121 );
			doppler_dd.setDoubleValue( 0 );
			doppler_mem.setBoolValue( 0 );
		} elsif ( mode == 1 ) {
			# 1 = stand by mode
			doppler_gs.setDoubleValue( 0 );
			doppler_dd.setDoubleValue( 0 );
			doppler_mem.setBoolValue( 1 );

		} else {
			# 2 = on land mode, 3 = on sea mode.
			var mem = test_op_conditions();
			doppler_mem.setBoolValue( mem );
			if ( mem == 0 ) {
				var hdg = ac_hdg.getValue();
				doppler_gs.setValue(gs_tmp);
				var drift_deg = hdg - true_track();
				while (drift_deg < -180)
					drift_deg += 360;
				while (drift_deg > 180)
					drift_deg -= 360;
				doppler_dd.setDoubleValue( -drift_deg );
			}
		}
	} else {
		# power off
		doppler_gs.setDoubleValue( 0 );
		doppler_dd.setDoubleValue( 0 );
		doppler_mem.setBoolValue( 0 );
	}
	settimer(update_loop, UPDATE_PERIOD);
}

# tests operating conditions
test_op_conditions = func {
	var c_ok = 1;
	var alt  = altitude.getValue();
	#var gs_tmp   = groundspeed.getValue(); # weird: I can't get this value this way...
	gs_tmp   = getprop("/velocities/groundspeed-kt");
	var p    = pitch.getValue();
	var r    = roll.getValue();
	if (( alt > min_alt_ft ) and ( alt < max_alt_ft )) {
		if (( gs_tmp > min_gs_kt ) and ( gs_tmp < max_gs_kt )) {
			if (( p > min_pitch_deg ) and ( p < max_pitch_deg )) {
				if (( r > min_roll_deg ) and ( r < max_roll_deg )) {
					c_ok = 0;
				}
			}
		}
	}
	return( c_ok );
}


true_track = func {
	var nfps = getprop("velocities/speed-north-fps");
	var efps = getprop("velocities/speed-east-fps");
	var true_track_deg =  geo.normdeg( 180 / ( math.pi / math.atan2( efps, nfps )));
	return( true_track_deg );
}



# Doppler panel controls
# -----------------------

doppler_knob = func {
	var input = arg[0];
	var knob = sel_mode.getValue();
	if (( input == 1 ) and (knob < 4 )) {
			sel_mode.setValue( knob + 1 );
	} elsif (( input == -1 ) and ( knob > 0 )) {
			sel_mode.setValue( knob - 1 );
	}
}

# init #################
init = func {
	print("Initializing A-6E Doppler");
	update_loop();
}

setlistener("/sim/signals/fdm-initialized", init);

