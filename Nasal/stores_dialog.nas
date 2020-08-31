
var stores_dialog = "";

var showStoresDialog = func
{
  stores_dialog = canvas.Window.new ([790,480],"dialog");
  stores_dialog.setPosition(40,40);
  stores_dialog.set("title","Payloads");
  stores_dialog.setCanvas(stores.new().get_canvas());

  #grabButton.addEventListener("drag", func(e) stores_dialog.move(e.deltaX, e.deltaY));
  #updateStationsDisplay();
}

var stores = {
    canvas_settings: {"name": "Stores Dialog",
                      "size": [790, 480],
                      "view": [790, 480],
                      "mipmapping": 0,
                    },
    new: func() {
        var m = {
            parents: [stores],
            stores_canvas: canvas.new(stores.canvas_settings),
        };
        m.root = m.stores_canvas.createGroup();

        m.p1opt = [
                    ["None",     
                                ["none"]],
                    ["Misc",
                                ["Droptank",]],
        ];
        m.p2opt = [
                    ["None",     
                                ["none"]],
                    ["Misc",
                                ["Droptank",]],
        ];
        m.p3opt = [
                    ["None",     
                                ["none"]],
                    ["Misc",
                                ["Droptank",]],
        ];
        m.p4opt = m.p1opt;
        m.p5opt = m.p3opt;

        # do the line splits manually
        # limit 20 characters per line
        # first line is the store name
        # 21 lines for info
        m.store_info = {
            "none"  :   [
                "There is nothing",
                "selected on this",
                "pylon.",
            ],
	    "Droptank": [
		"Aero ID 300",
		"300 Gal droptank",
	    ],

        };

        m.pylon_selected = 0;
        m.outer_group_selected = 0;
        m.inner_group_selected = 0;

        m.font_size = 18;
        m.font_color = [1,1,1];
        m.selected_color = [0,1,0];

        m.p1 = m.root.createChild("text", "p3label")
                    .setTranslation(10, 20)
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.selected_color)
                    .setText("Pylon 1");
                    
        m.p1store = m.root.createChild("text", "p2store")
                    .setTranslation(10,40)
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.selected_color)
                    .setText(getprop("/payload/weight[0]/selected"));

        m.p1click = m.root.createChild("path")
                    .setTranslation(10,5)
                    .horiz(180)
                    .vert(50)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.pylon_click(0)});
                    
        m.p2 = m.root.createChild("text", "p2label")
                    .setTranslation(10, 80)
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.font_color)
                    .setText("Pylon 2");
                    
        m.p2store = m.root.createChild("text", "p1store")
                    .setTranslation(10,100)
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.font_color)
                    .setText(getprop("/payload/weight[1]/selected"));

        m.p2click = m.root.createChild("path")
                    .setTranslation(10,65)
                    .horiz(180)
                    .vert(50)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.pylon_click(1)});
                    
        m.p3 = m.root.createChild("text", "pclabel")
                    .setTranslation(10, 140)
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.font_color)
                    .setText("Pylon 3");
                    
        m.p3store = m.root.createChild("text", "pcstore")
                    .setTranslation(10,160)
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.font_color)
                    .setText(getprop("/payload/weight[2]/selected"));

        m.p3click = m.root.createChild("path")
                    .setTranslation(10,125)
                    .horiz(180)
                    .vert(50)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.pylon_click(2)});
                    
        m.p4 = m.root.createChild("text", "p2label")
                    .setTranslation(10, 200)
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.font_color)
                    .setText("Pylon 4");
                    
        m.p4store = m.root.createChild("text", "p2store")
                    .setTranslation(10,220)
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.font_color)
                    .setText(getprop("/payload/weight[3]/selected"));

        m.p4click = m.root.createChild("path")
                    .setTranslation(10,185)
                    .horiz(180)
                    .vert(50)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.pylon_click(3)});
                    
        m.p5 = m.root.createChild("text", "p4label")
                    .setTranslation(10, 260)
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.font_color)
                    .setText("Pylon 5");
                    
        m.p5store = m.root.createChild("text", "p4store")
                    .setTranslation(10,280)
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.font_color)
                    .setText(getprop("/payload/weight[4]/selected"));

        m.p5click = m.root.createChild("path")
                    .setTranslation(10,245)
                    .horiz(180)
                    .vert(50)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.pylon_click(4)});                    

        m.outerselectiongroup = [];
        m.innerselectiongroup = [];
        m.infobox = [];
        for ( var i = 0; i < 23; i = i + 1 ) {
            append(m.outerselectiongroup, m.root.createChild("text")
                    .setTranslation(200,20 + (20 * i))
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.font_color));
            append(m.innerselectiongroup, m.root.createChild("text")
                    .setTranslation(400,20 + (20 * i))
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size, 1.0)
                    .setColor(m.font_color));
            append(m.infobox, m.root.createChild("text")
                    .setTranslation(600,20 + (20 * i))
                    .setAlignment("left-center")
                    .setFont("LiberationFonts/LiberationMono-Regular.ttf")
                    .setFontSize(m.font_size * 0.8, 1.0)
                    .setColor(m.font_color));
        }

        m.infobox[0].setColor(m.selected_color);

        m.infobox_outline = m.root.createChild("path")
                    .setTranslation(600,7)
                    .horiz(180)
                    .vert(460)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1);

        m.outerselectionclick = [
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 0))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(0);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 1))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(1);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 2))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(2);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 3))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(3);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 4))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(4);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 5))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(5);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 6))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(6);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 7))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(7);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 8))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(8);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 9))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(9);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 10))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(10);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 11))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(11);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 12))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(12);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 13))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(13);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 14))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(14);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 15))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(15);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 16))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(16);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 17))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(17);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 18))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(18);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 19))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(19);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 20))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(20);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 21))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(21);}),
            m.root.createChild("path")
                    .setTranslation(200,7 + (20 * 22))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.outer_click(22);}),
        ];

        m.innerselectionclick = [
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 0))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(0);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 1))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(1);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 2))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(2);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 3))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(3);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 4))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(4);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 5))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(5);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 6))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(6);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 7))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(7);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 8))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(8);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 9))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(9);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 10))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(10);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 11))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(11);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 12))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(12);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 13))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(13);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 14))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(14);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 15))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(15);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 16))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(16);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 17))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(17);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 18))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(18);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 19))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(19);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 20))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(20);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 21))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(21);}),
            m.root.createChild("path")
                    .setTranslation(400,7 + (20 * 22))
                    .horiz(180)
                    .vert(20)
                    .horiz(-180)
                    .close()
                    .setColor(1,1,1,1)
                    .addEventListener("click",func(){m.inner_click(22);}),
        ];

        m.selection_map = [m.p1opt, m.p2opt, m.p3opt, m.p4opt, m.p5opt];
        m.pylon_map = [   [m.p1,m.p1store],
                          [m.p2,m.p2store],
                          [m.p3,m.p3store],
                          [m.p4,m.p4store],
                          [m.p5,m.p5store],
                        ];
        m.pylon_click(0);
        return m;
    },
    get_canvas: func() {
        return me.stores_canvas;
    },
    # if you click on a new pylon (or this is the first runthrough):
    # run this with opt being the internal pylon number
    # if a new outer group is selected, update with both opt and out being the outer group name
    selections_update: func(opt = 0, out = -1) {
        me.selected = getprop("/payload/weight["~opt~"]/selected");
        if (out == -1) {
            me.outer_selected = me.find_payload_og(opt, me.selected);
        } else {
            me.outer_selected = out;
        }
        me.i = -1;
        foreach(var og; me.selection_map[opt]) {
            me.i = me.i + 1;
            me.outerselectiongroup[me.i].setText(og[0]);
            if(og[0] == me.selection_map[opt][me.outer_selected][0]) {
                me.outerselectiongroup[me.i].setColor(me.selected_color);
                me.j = -1;
                foreach(var ig; og[1]) {
                    me.j = me.j + 1;
                    me.innerselectiongroup[me.j].setText(ig);
                    if (ig == me.selected) {
                        me.innerselectiongroup[me.j].setColor(me.selected_color);
                    } else {
                        me.innerselectiongroup[me.j].setColor(me.font_color);
                    }
                }
            } else {
                me.outerselectiongroup[me.i].setColor(me.font_color);
            }
        }
        for (var i = me.i + 1; i < 23; i = i + 1) {
            me.outerselectiongroup[i].setText("");
        }
        for (var i = me.j + 1; i < 23; i = i + 1) {
            me.innerselectiongroup[i].setText("");
        }
    },

    pylon_click: func(pyl) {
        for(var i = 0; i < size(me.pylon_map); i = i + 1) {
            if (i == pyl) {
                me.pylon_map[i][0].setColor(me.selected_color);
                me.pylon_map[i][1].setColor(me.selected_color);
            } else {
                me.pylon_map[i][0].setColor(me.font_color);
                me.pylon_map[i][1].setColor(me.font_color);
            }
        }
        me.pylon_selected = pyl;
        me.selections_update(pyl);
        me.write_info(me.selected);
    },

    outer_click: func(out) {
        me.selected = getprop("/payload/weight["~me.pylon_selected~"]/selected");
        if (out >= size(me.selection_map[me.pylon_selected])) {
            return;
        }
        me.outer_selected = out;
        for (var i = 0; i < size(me.selection_map[me.pylon_selected]); i = i + 1 ) {
            if (i == out) {
                me.outerselectiongroup[i].setColor(me.selected_color);
            } else {
                me.outerselectiongroup[i].setColor(me.font_color);
            }
        }
        for (var i = 0; i < 23; i = i + 1) {
            me.innerselectiongroup[i].setText("");
        }
        for (var i = 0; i < size(me.selection_map[me.pylon_selected][out][1]); i = i + 1) {
            me.innerselectiongroup[i].setText(me.selection_map[me.pylon_selected][out][1][i]);
            if (me.selection_map[me.pylon_selected][out][1][i] == me.selected) {
                me.innerselectiongroup[i].setColor(me.selected_color);
            } else {
                me.innerselectiongroup[i].setColor(me.font_color);
            }
        }
    },

    inner_click: func(ig) {
        if (ig >= size(me.selection_map[me.pylon_selected][me.outer_selected][1])) {
            return;
        }
        me.sel = me.selection_map[me.pylon_selected][me.outer_selected][1][ig];
        # me.weight = payloads.payloads[me.sel].weight;
        # setprop("/payloadweight["~me.pylon_selected~"]/selected",me.sel);
        # setprop("/payload/weight["~me.pylon_selected~"]/weight-lb",me.weight);
	pylonManager.loadPylon(me.pylon_selected, me.sel);
        me.pylon_map[me.pylon_selected][1].setText(me.sel);
        me.write_info(me.sel);
        me.outer_click(me.outer_selected);
    },

    find_payload_og: func(opt, search) {
        for (var i = 0; i < size(me.selection_map[opt]);i = i + 1){
            for (var j = 0; j < size(me.selection_map[opt][i][1]); j = j + 1){
                if ( me.selection_map[opt][i][1][j] == search ) {
                    return i;
                }
            }
        }
    },

    write_info: func(name) {
        me.write_array = [];
	# clear out old info
        foreach(var info; keys(me.store_info)) {
            if (info == name) {
                me.write_array = me.store_info[info];
            }
        }
        me.infobox[0].setText(name);
        for(me.i = 0; me.i < size(me.write_array); me.i = me.i + 1){
            me.infobox[me.i+1].setText(me.write_array[me.i]);
        }
        for(me.i = me.i; me.i < size(me.infobox)-1; me.i = me.i + 1){
            me.infobox[me.i+1].setText("");
        }

    },
};
