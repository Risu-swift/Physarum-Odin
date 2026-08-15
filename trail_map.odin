package main

import "core:math/rand"
import rl "vendor:raylib"

trailMap : []Color32
trailMapTex : rl.Texture2D

create_trailMap :: proc() {

	trailMap = make([]Color32, sim_width * sim_height)

	trailMapTex = rl.LoadTextureFromImage(rl.Image {
		data = raw_data(trailMap),
		width = sim_width,
		height = sim_height,
		mipmaps = 1,
		format = .UNCOMPRESSED_R8G8B8A8
	})
}

render_trailMap :: proc() {

	for &p in trailMap{
		p = {
			u8(rand.float32() * 254),	
			u8(rand.float32() * 254),	
			u8(rand.float32() * 254),	
			u8(rand.float32() * 254),	
		}
	}

	rl.UpdateTexture(trailMapTex, raw_data(trailMap))
	
	rl.DrawTexture(trailMapTex, 0, 0, rl.WHITE)

}
