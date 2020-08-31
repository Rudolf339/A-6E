# Pylon manager for A-6E
# Author: Jüttner Domokos
# License: GPLv2

# name: [id, count, rack]

var stores = {Droptank: {id:"aero300", count:1}};

loadPylon = func (n, selected) {
    n = sprintf("%i", n);
    if (selected != getprop("/payload/weight[" ~ n ~ "]/selected")) {
	setprop("/payload/weight[" ~ n ~ "]/selected", selected);
    }
    if (selected != "none") {
	var id = stores[selected].id;
	var mass = getprop("/payload/armament/" ~ id ~ "/weight-launch-lbs");
	var cd = getprop("/payload/armament/" ~ id ~ "/drag-coeff");
	var count = stores[selected].count;
	var eda = getprop("/payload/armament/" ~ id ~ "/cross-section-sqft") * count;
    } else {
	var mass = 0;
	var cd = 0;
	var eda = 0;
	var id = 0;
	var count = 0;
    }
    setprop("/payload/weight[" ~ n ~ "]/weight-lb", mass);
    setprop("/payload/weight[" ~ n ~ "]/eda", eda);
    setprop("/payload/weight[" ~ n ~ "]/cd", cd);
    setprop("/payload/weight[" ~ n ~ "]/id", id);
    setprop("/payload/weight[" ~ n ~ "]/count", count);
}

# load empty stores for startup
for (var i = 1; i < 5; i += 1) {
    loadPylon(i, "none");
}

# Set up listeners for stores selection
setlistener("/payload/weight/selected", func { loadPylon(0, getprop("/payload/weight/selected")) });
setlistener("/payload/weight[1]/selected", func { loadPylon(1, getprop("/payload/weight[1]/selected")) });
setlistener("/payload/weight[2]/selected", func { loadPylon(2, getprop("/payload/weight[2]/selected")) });
setlistener("/payload/weight[3]/selected", func { loadPylon(3, getprop("/payload/weight[3]/selected")) });
setlistener("/payload/weight[4]/selected", func { loadPylon(4, getprop("/payload/weight[4]/selected")) });
