# TACAN BIT test
var tacan_bit = setlistener("controls/instrumentation/tacan/BIT", func (node) {
    if (node.getValue() == 0){
	setprop("instrumentation/tacan/BIT-complete", 0);
	setprop("instrumentation/tacan/BIT-running", 1);
	setprop("instrumentation/tacan/BIT-bearing", 0);
	setprop("instrumentation/tacan/BIT-range", 0);
	settimer(func {
	    interpolate("instrumentation/tacan/BIT-bearing", rand() * 8, 0.5);
	    interpolate("instrumentation/tacan/BIT-range", 1.6 + rand() * 0.4, 0.5);
		 }, 9 + rand() * 2);
	settimer(func {
	    var power = getprop("systems/electrical/outputs/tacan") > 24;
	    if (getprop("instrumentation/tacan/serviceable") and power)
	    {
		setprop("instrumentation/tacan/BIT-complete", 1);
	    } elsif (power) {
		setprop("instrumentation/tacan/BIT-complete", -1);
	    } else {
		setprop("instrumentation/tacan/BIT-complete", 0);
	    }
	    interpolate("instrumentation/tacan/BIT-bearing", 0, 0.5);
	    interpolate("instrumentation/tacan/BIT-range", 0, 0.5);
	    setprop("instrumentation/tacan/BIT-running", 0);
		 }, 22 + 4 * rand());
    }
});
		
