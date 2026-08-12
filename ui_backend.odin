package main

import mu "vendor:microui"
import rl "vendor:raylib"


Color32 :: [4]u8

atlas : rl.Texture2D

@(deferred_none = ui_shutdown)
ui_init :: proc(ctx : ^mu.Context) {
	
	//Init micro ui
	mu.init(ctx)

	//set atlas
	ctx.text_height = mu.default_atlas_text_height
	ctx.text_width = mu.default_atlas_text_width

	//setup microui font/text atlas

	pixels := make([]Color32, mu.DEFAULT_ATLAS_WIDTH * mu.DEFAULT_ATLAS_HEIGHT)

	for a,i in mu.default_atlas_alpha do pixels[i] = {255,255,255,a}
	atlas = rl.LoadTextureFromImage(rl.Image{
		data = raw_data(pixels),
		width = mu.DEFAULT_ATLAS_WIDTH,
		height = mu.DEFAULT_ATLAS_HEIGHT,
		mipmaps = 1,
		format = .UNCOMPRESSED_R8G8B8A8 
	})
	delete(pixels)

}

ui_poll_input :: proc(ctx : ^mu.Context) {
	m := rl.GetMousePosition()
	mu.input_mouse_move(ctx, i32(m.x), i32(m.y))

	if(rl.IsMouseButtonDown(.LEFT)) {
		mu.input_mouse_down(ctx, i32(m.x), i32(m.y), .LEFT)
	}

	if(rl.IsMouseButtonDown(.RIGHT)) {
		mu.input_mouse_down(ctx, i32(m.x),i32(m.y), .RIGHT)
	}

	if(rl.IsMouseButtonUp(.LEFT)) {
		mu.input_mouse_up(ctx, i32(m.x), i32(m.y), .LEFT)
	}

	if(rl.IsMouseButtonUp(.RIGHT)) {
		mu.input_mouse_up(ctx, i32(m.x), i32(m.y), .RIGHT)
	}

}

ui_render :: proc(ctx: ^mu.Context) {
	command : ^mu.Command

	for cmd in mu.next_command_iterator(ctx, &command) {

		#partial switch c in cmd {
			case ^mu.Command_Rect:
				rl.DrawRectangle(c.rect.x, c.rect.y, c.rect.w, c.rect.h, transmute(rl.Color)c.color)
			case ^mu.Command_Text:
		}

	}

}

ui_shutdown :: proc() {
	rl.UnloadTexture(atlas)
}
