extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const WorldRenderer = preload("res://Scripts/WorldRenderer.gd")

onready var w_renderer: WorldRenderer = get_node("WorldOrigin")

# Called when the node enters the scene tree for the first time.
func _ready():
	var gen = WorldGen.new(5)
	var chunks = []
	for x in range(-2, 3):
		for z in range(-2, 3):
			var c = gen.generate_chunk(x, z)
			chunks.append(c)

	var not_same_count = 0
	for i in range(16):
		for j in range(128):
			for k in range(16):
				var c1: Chunk = chunks[0]
				var c2: Chunk = chunks[1]
				if c1.get_block_pos(i,j,k).block_id != c2.get_block_pos(i,j,k).block_id:
					not_same_count+=1
					print_debug("notsame y: "+ str(j))
	print_debug('not_same_count: ' + str(not_same_count))

	for chunk in chunks:
		w_renderer.render_chunk(chunk)

#	var c1 = gen.generate_chunk(0, 1)
#	var c2 = gen.generate_chunk(0, 0)
#	w_renderer.render_chunk(c1)
#	w_renderer.render_chunk(c2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
