


var UPDATE_PERIOD = 0.1;

var ticker      = props.globals.getNode("sim/model/A-6E/instrumentation/ticker", 1);
var ikts        = props.globals.getNode("velocities/airspeed-kt");
var aft_ballast = props.globals.getNode("sim/model/A-6E/controls/flight/CG-trim-aft", 1);
var fwd_ballast = props.globals.getNode("sim/model/A-6E/controls/flight/CG-trim-fwd", 1);
var Vx          = props.globals.getNode("velocities/uBody-fps", 1);
var Vy          = props.globals.getNode("velocities/vBody-fps", 1);
var Vz          = props.globals.getNode("velocities/wBody-fps", 1);
var vdi_vel_y   = props.globals.getNode("sim/model/A-6E/instrumentation/vdi/velocity_marker_y", 1);
var vdi_vel_z   = props.globals.getNode("sim/model/A-6E/instrumentation/vdi/velocity_marker_z", 1);
#var wind_deg   = props.globals.getNode("environment/wind-from-heading-deg");
#var wind_kts   = props.globals.getNode("environment/wind-speed-kt");
var ac_hdg      = props.globals.getNode("/orientation/heading-deg", 1);
var g_curr              = props.globals.getNode("accelerations/pilot-g");
var g_max               = props.globals.getNode("sim/model/A-6E/instrumentation/g-meter/g-max", 1);
var g_min               = props.globals.getNode("sim/model/A-6E/instrumentation/g-meter/g-min", 1);
var TrueHdg          = props.globals.getNode("orientation/heading-deg");
var Hsd              = props.globals.getNode("sim/model/A-6E/instrumentation/hsd", 1);
var MagHdg           = props.globals.getNode("orientation/heading-magnetic-deg");
var MagDev           = props.globals.getNode("orientation/local-mag-dev", 1);
var Tc               = props.globals.getNode("instrumentation/tacan");
var Vtc              = props.globals.getNode("instrumentation/nav[1]");
var TcFreqs          = Tc.getNode("frequencies");
var TcTrueHdg        = Tc.getNode("indicated-bearing-true-deg");
var TcMagHdg         = Tc.getNode("indicated-mag-bearing-deg", 1);
var TcIdent          = Tc.getNode("ident");
var TcServ           = Tc.getNode("serviceable");
var TcXY             = Tc.getNode("frequencies/selected-channel[4]");

var mag_dev = 0;
var tc_mode = 0;


# Main loop ###############
var cnt = 0;

var update_loop = func {
        A6Echronograph.update_chrono();
        tacan_update();
        inc_ticker();
        g_min_max();
        auto_trim();
        vdi_vel_marker();
        vdi_drift_angle();
        if ( cnt == 10 ) {
                # done each 1 sec.
                local_mag_deviation();
                cnt = 0;
        } else {
                cnt += 1;
        }
        settimer(update_loop, UPDATE_PERIOD);
}



# functions ###############

var inc_ticker = func {
        # used for VDI background continuous translation animation
        var tick = ticker.getValue();
        tick += 1 ;
        ticker.setDoubleValue(tick);
}

var g_min_max = func {
        # records g min and max values
        var curr = g_curr.getValue();
        var max = g_max.getValue();
        var min = g_min.getValue();
        if ( curr >= max ) {
                g_max.setDoubleValue(curr);
        } elsif ( curr <= min ) {
                g_min.setDoubleValue(curr);
        }
}


var auto_trim = func {
        # Move a ballast from one Yasim weight point to another
        # depending on the airspeed of the a/c. 
        var kts = ikts.getValue();
        var new_fwd = 0;
        if (kts > 150) { new_fwd = 30*(kts-150); }
        if (new_fwd > 7000) { new_fwd = 7000 }
        var new_aft = 7000 - new_fwd;
        
        aft_ballast.setDoubleValue(new_aft);
        fwd_ballast.setDoubleValue(new_fwd);
}


# Compute local magnetic deviation.
var local_mag_deviation = func {
        var true = TrueHdg.getValue();
        var mag = MagHdg.getValue();
        mag_dev = geo.normdeg( mag - true );
        if ( mag_dev > 180 ) mag_dev -= 360;
        MagDev.setValue(mag_dev); 
}


var tacan_update = func {
        #var tc_mode = TcModeSwitch.getValue();
        var tc_mode = 1;
        if ( tc_mode != 0 and tc_mode != 4 ) {

                # Get magnetic tacan bearing.
                var true_bearing = TcTrueHdg.getValue();
                var mag_bearing = geo.normdeg( true_bearing + mag_dev );
                if ( true_bearing != 0 ) {
                        TcMagHdg.setDoubleValue( mag_bearing );
                } else {
                        TcMagHdg.setDoubleValue(0);
                }

                # Get TACAN radials on HSD's Course Deviation Indicator.
                # CDI works with ils OR tacan OR vortac (which freq is tuned from the tacan panel).
                #var tcnid = TcIdent.getValue();
                #var vtcid = VtcIdent.getValue();
                #if ( tcnid == vtcid ) {
                        # We have a VORTAC.
                        #HsdFromFlag.setBoolValue(VtcFromFlag.getBoolValue());
                        #HsdToFlag.setBoolValue(VtcToFlag.getBoolValue());
                        #HsdCdiDeflection.setValue(VtcHdgDeflection.getValue());
                #} else {
                        # We have a legacy TACAN.
                        #var tcn_toflag = 1;
                        #var tcn_fromflag = 0;
                        #var tcn_bearing = TcMagHdg.getValue();
                        #var radial = VtcRadialDeg.getValue();
                        #var d = tcn_bearing - radial;
                        #if ( d > 180 ) { d -= 360 } elsif ( d < -180 ) { d += 360 }
                        #if ( d > 90 ) {
                                #d -= 180;
                                #tcn_toflag = 0;
                                #tcn_fromflag = 1;
                        #} elsif ( d < - 90 ) {
                                #d += 180;
                                #tcn_toflag = 0;
                                #tcn_fromflag = 1;
                        #}
                        #if ( d > 10 ) d = 10 ;
                        #if ( d < -10 ) d = -10 ;
                        #HsdFromFlag.setBoolValue(tcn_fromflag);
                        #HsdToFlag.setBoolValue(tcn_toflag);
                        #HsdCdiDeflection.setValue(d);
                #}
        } else {
                TcMagHdg.setDoubleValue(0);
        }
}

var vdi_vel_marker = func {
        # displays impact point on the VDI display
        var vx = Vx.getValue();
        var vy = Vy.getValue();
        var vz = Vz.getValue();
        if (vx > 0.1 ) {
                var vely = vy/vx;
                var velz = vz/vx;
                vdi_vel_y.setDoubleValue(vely);
                vdi_vel_z.setDoubleValue(velz);
        }
}

var vdi_drift_angle = func {
        #var wdeg = wind-deg.getValue();
        #var wkt = wind_kt.getValue();
        var achdg = ac_hdg.getValue();
}

# main_init #################
var main_init = func {
        print("Initializing A-6E Intruder systems");
        ticker.setDoubleValue(0);
        vdi_vel_y.setDoubleValue(0);
        vdi_vel_z.setDoubleValue(0);
        aircraft.data.load();
        foreach (var f_tc; TcFreqs.getChildren()) {
                aircraft.data.add(f_tc);
        }
        A6Econtrols.tacan_switch_init();
        phd.PHD_init();
        settimer(func { update_loop() }, 0.5);
}

var main_init_listener = setlistener("sim/signals/fdm-initialized", func {
        setprop("/fdm/jsbsim/position/h-sl-ft/", getprop("/fdm/jsbsim/position/h-sl-ft")+4);
        main_init();
        removelistener(main_init_listener);
 }, 0, 0);


# Remember Radar Altimeter and lighting settings.
aircraft.data.add(
        "controls/instrumentation/radalt/limit-bug",
        "controls/instrumentation/asi/speed-limit-bug",
        "controls/lighting/beacon",
        "controls/lighting/taxi-light",
        "sim/model/A-6E/controls/lighting/pylons-lts",
        "controls/lighting/instruments-norm",
        "controls/lighting/panel-norm",
        "sim/model/A-6E/controls/lighting/index-norm",
        "sim/model/A-6E/controls/lighting/tail-lt",
        "sim/model/A-6E/controls/lighting/wings-lts",
        "sim/model/A-6E/controls/lighting/formation-lts",
        "sim/model/A-6E/controls/lighting/flood-lts"
);


