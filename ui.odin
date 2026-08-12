package main

import mu "vendor:microui"

ui_update :: proc(ctx : ^mu.Context) {

	if mu.window(ctx, "Edit Params", mu.Rect{0,0,200,100}) {
		
		mu.layout_row(ctx, {-1}, 0)
		mu.slider(ctx, &sensor_angle, 0.0, 90.0,)

	}


}
