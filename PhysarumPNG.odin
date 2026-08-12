package main

import "core:math/rand"
import mu "vendor:microui"
import rl "vendor:raylib"


Agent :: struct {
	pos:   rl.Vector2,
	angle: f32,
}

AGENT_COUNT: int : 5
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


		rl.BeginDrawing()
			render_ui()
			render_agents(agents[:])
		rl.EndDrawing()

		free_all(context.temp_allocator)
	}

	//Close window on exit
	rl.CloseWindow()
}

spawn_agents :: proc(agents: []Agent) {
	for &agent in agents {
		pos: rl.Vector2
		pos.x = rand.float32() * f32(sim_width)
		pos.y = rand.float32() * f32(sim_height)
		agent = {
			pos   = pos,
			angle = rand.float32() * f32(360),
		}

	}

}

update_agents :: proc(trailMap: rl.Image, agents: []Agent) {


}

render_ui :: proc() {
	rl.GuiSlider(rl.Rectangle{40, 40, 40, 40}, "Sensor Angle", "", &sensor_angle, 0.0, 60.0)
}

render_agents :: proc(agents: []Agent) {
	for agent in agents {
		render_agent(agent)

	}
}

render_agent :: proc(agent: Agent) {
	//Draw the lines for the sensore
	upVector: rl.Vector2 = {0, -1}

	rotatedVec := rl.Vector2Rotate(upVector, agent.angle * rl.DEG2RAD)
	leftSensorVec := rl.Vector2Rotate(rotatedVec, sensor_angle * rl.DEG2RAD)
	rightSensorVec := rl.Vector2Rotate(rotatedVec, -sensor_angle * rl.DEG2RAD)

	endpos := agent.pos + rotatedVec * sensor_distance
	endleftpos := agent.pos + leftSensorVec * sensor_distance
	endrightpos := agent.pos + rightSensorVec * sensor_distance

	//rotatingVec :=
	rl.DrawLineV(agent.pos, endpos, rl.WHITE)
	rl.DrawLineV(agent.pos, endleftpos, rl.WHITE)
	rl.DrawLineV(agent.pos, endrightpos, rl.WHITE)

	//Draw the agent itself
	rl.DrawCircleV(agent.pos, 3.0, rl.RED)
}
