package main

import rl "vendor:raylib"
import "core:math/rand"

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


