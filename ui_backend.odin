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
				x :=  f32(c.pos.x)

				for ch in c.str {
					//Get Rect from Font Atlas
					src := mu.default_atlas[mu.DEFAULT_ATLAS_FONT + min(int(ch),127)]
					srcRect := rl.Rectangle{
						f32(src.x),
						f32(src.y),
						f32(src.w),
						f32(src.h)
					}
					//Render the font
					rl.DrawTextureRec(atlas, srcRect, {x,f32(c.pos.y)}, transmute(rl.Color)c.color)
					x += f32(src.w)
				}

			case ^mu.Command_Icon:
				rect := mu.default_atlas[c.id]
				posx := c.rect.x + (c.rect.w - rect.w) / 2
				posy := c.rect.y + (c.rect.h - rect.h) / 2

				srcRect := rl.Rectangle {
					f32(rect.x),
					f32(rect.y),
					f32(rect.w),
					f32(rect.h)
				}

				rl.DrawTextureRec(atlas, srcRect, {f32(posx), f32(posy)} , transmute(rl.Color)c.color )

			//TODO : Implement jump and clip

		}

	}

}

ui_shutdown :: proc() {
	rl.UnloadTexture(atlas)
}
