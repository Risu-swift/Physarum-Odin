package main

import mu "vendor:microui"
import rl "vendor:raylib"


Agent :: struct {
	pos:   rl.Vector2,
	angle: f32,
}

AGENT_COUNT: int : 50
SIM_STEPS: int = 5
sensor_distance: f32 = 50.0
sensor_angle: f32 = 30.0

WIDTH: i32 : 1280
HEIGHT: i32 : 720

sim_width: i32 : 960
sim_height: i32 : 720



main :: proc() {

	//Create agents and spawn them in canvas
	agents: [AGENT_COUNT]Agent
	spawn_agents(agents[:])

	//Inititalize window
	rl.InitWindow(WIDTH, HEIGHT, "Physarum sim")

	//set frame cap
	rl.SetTargetFPS(60)


	//init micro ui with context
	mu_ctx := new(mu.Context)
	defer free(mu_ctx)
	ui_init(mu_ctx)


	step := 0
	for !rl.WindowShouldClose() {
		if (step < SIM_STEPS) {
			//update_agents()
			step += 1
		}
		
		//poll input and Update ui
		ui_poll_input(mu_ctx)

		mu.begin(mu_ctx)
			ui_update(mu_ctx)
		mu.end(mu_ctx)

		create_trailMap()

		rl.BeginDrawing()
			rl.ClearBackground(rl.BLACK)
			render_trailMap()
			//render_agents(agents[:])
			//ui_render(mu_ctx)
		rl.EndDrawing()

		free_all(context.temp_allocator)
	}

	rl.UnloadTexture(trailMapTex)
	//Close window on exit
	rl.CloseWindow()
}




