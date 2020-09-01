# Pylon manager for A-6E
# Author: Jüttner Domokos
# License: GPLv2

# name: [id, count, rack]

var UPDATE_PERIOD = 0.1;
var stores = {Droptank: {id:"aero300", count:1}};

var ext = {0: {id: props.globals.getNode("/payload/weight/id"),
	       level: props.globals.getNode("/consumables/fuel/tank[8]/level-gal_us"),
	      },
	   1: {id: props.globals.getNode("/payload/weight[1]/id"),
	       level: props.globals.getNode("/consumables/fuel/tank[9]/level-gal_us"),
	      },
	   2: {id: props.globals.getNode("/payload/weight[2]/id"),
	       level: props.globals.getNode("/consumables/fuel/tank[10]/level-gal_us"),
	      },
	   3: {id: props.globals.getNode("/payload/weight[3]/id"),
	       level: props.globals.getNode("/consumables/fuel/tank[11]/level-gal_us"),
	      },
	   4: {id: props.globals.getNode("/payload/weight[4]/id"),
	       level: props.globals.getNode("/consumables/fuel/tank[12]/level-gal_us"),
	      },
	  };

var loadPylon = func (n, selected) {
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
	var id = "none";
	var count = 0;
    }

    # load fuel tanks if needed
    if (id == "aero300" or id == "d704") {
	ext[num(n)].level.setValue(300);
    } else {
	ext[num(n)].level.setValue(0);
    }
    setprop("/payload/weight[" ~ n ~ "]/weight-lb", mass);
    setprop("/payload/weight[" ~ n ~ "]/eda", eda);
    setprop("/payload/weight[" ~ n ~ "]/cd", cd);
    setprop("/payload/weight[" ~ n ~ "]/id", id);
    setprop("/payload/weight[" ~ n ~ "]/count", count);

}

var droptank_check = func {
    for (var n = 0; n < 5; n += 1) {
	if (ext[n].id.getValue() != "aero300" and
	    ext[n].id.getValue() != "d704" and
	    ext[n].level.getValue() != 0) {
	    ext[n].level.setValue(0);
	}
    }
}

var armament_loop = func {
    droptank_check();
    settimer(armament_loop, UPDATE_PERIOD);
}

var main_init = func {
    print("#### Pylon Manager started ####");
    # load empty stores for startup
    for (var i = 0; i < 5; i += 1) {
	loadPylon(i, "none");
    }
    armament_loop();
}

var main_init_listener = setlistener("sim/signals/fdm-initialized", func {
    main_init();
    removelistener(main_init_listener);
}, 0, 0);
