# License: GPLv2+
# Author: Domokos Juttner

var msg_window = screen.window.new(x:nil, y:-15, maxlines:1, autoscroll:0);
var msg_window_timer = maketimer(3, func { msg_window.clear(); });
msg_window_timer.singleShot = 1;

var printvalue = func (txt) {
    msg_window.write(txt);
    msg_window_timer.start();
}

var start = setlistener("sim/signals/fdm-initialized", func {
    setlistener("/engines/engine/cutoff", func(node) {
	printvalue("engine 1 " ~ (node.getValue() ? "OFF": "IDLE"));},0,0);
    setlistener("/engines/engine[1]/cutoff", func(node) {
	printvalue("engine 2 " ~ (node.getValue() ? "OFF": "IDLE"));},0,0);
    setlistener("/controls/flight/gnd-spoiler-arm", func(node) {
	printvalue("Flaperon popup " ~ (node.getValue() ? "ARM": "OFF"));},0,0);
    setlistener("/controls/flight/spin-assist", func(node) {
	printvalue("Spin assist " ~ (node.getValue() ? "ON": "OFF"));},0,0);
},0,0);
