# License: GPLv2+
# Author: Domokos Juttner

var starter = func (n) {
    n1 = props.globals.getNode("engines/engine["~n~"]/n1");
    if (!getprop("controls/engines/engine["~ sprintf("%i", 1-n) ~"]/starter") &&
	getprop("gear/gear/wow"){
	setprop("controls/engines/engine["~n~"]/starter", 1);
	var loop = maketimer(1, func {
	    if (n1.getValue() >= 30) {
		setprop("controls/engines/engine["~n~"]/starter", 0);
		loop.stop();
	    }
			     });
	loop.start();
    }
}
