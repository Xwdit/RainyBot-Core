extends RefCounted


var _shader:Shader


func get_indexed_datas(image: Image, colors: Array) -> PackedByteArray:
	_shader = preload("./lookup_color.gdshader")
	return _convert(image, colors)


func get_similar_indexed_datas(image: Image, colors: Array) -> PackedByteArray:
	_shader = preload("./lookup_similar.gdshader")
	return _convert(image, colors)


func _convert(image: Image, colors: Array) -> PackedByteArray:
	var vp:RID = RenderingServer.viewport_create()
	var canvas:RID = RenderingServer.canvas_create()
	RenderingServer.viewport_attach_canvas(vp, canvas)
	RenderingServer.viewport_set_size(vp, image.get_width(), image.get_height())
	RenderingServer.viewport_set_disable_3d(vp, true)
	RenderingServer.viewport_set_active(vp, true)

	var ci_rid:RID = RenderingServer.canvas_item_create()
	RenderingServer.viewport_set_canvas_transform(vp, canvas, Transform2D())
	RenderingServer.canvas_item_set_parent(ci_rid, canvas)
	var texture:ImageTexture = ImageTexture.create_from_image(image)
	RenderingServer.canvas_item_add_texture_rect(
		ci_rid, Rect2(Vector2(0, 0), image.get_size()), texture
	)

	var mat_rid:RID = RenderingServer.material_create()
	RenderingServer.material_set_shader(mat_rid, _shader.get_rid())
	var lut:Image = Image.new()
	lut.create(256, 1, false, Image.FORMAT_RGB8)
	lut.fill(Color8(int(colors[0][0]), int(colors[0][1]), int(colors[0][2])))
	for i in colors.size():
		lut.set_pixel(i, 0, Color8(int(colors[i][0]), int(colors[i][1]), int(colors[i][2])))
	var lut_tex:ImageTexture = ImageTexture.create_from_image(image)
	RenderingServer.material_set_param(mat_rid, "lut", lut_tex.get_rid())
	RenderingServer.canvas_item_set_material(ci_rid, mat_rid)

	RenderingServer.viewport_set_update_mode(vp, RenderingServer.VIEWPORT_UPDATE_ONCE)
	image = RenderingServer.texture_2d_get(RenderingServer.viewport_get_texture(vp))

	RenderingServer.free_rid(vp)
	RenderingServer.free_rid(canvas)
	RenderingServer.free_rid(ci_rid)
	RenderingServer.free_rid(mat_rid)

	image.convert(Image.FORMAT_R8)
	return image.get_data()
