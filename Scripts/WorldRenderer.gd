extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const ChunkRenderer = preload("res://Scripts/ChunkRenderer.gd")

var rendered_chunk_coords = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func render_chunk(c: Chunk) -> void:
	var cx: int = c.cx
	var cz: int = c.cz
	var key = str(cx) + ',' + str(cz)
	if rendered_chunk_coords.has(key):
		return
	rendered_chunk_coords[key] = true
	print_debug("render_chunk start @" + str(cx) +","+str(cz))
	
	# spawn ChunkRenderer
	var instance_spatial = Spatial.new()
	instance_spatial.set_script(ChunkRenderer)
	instance_spatial.name = "ChunkRenderer-" + str(cx) + "-" + str(cz)
	var instance: ChunkRenderer = instance_spatial
#	print_debug("spawned ChunkRenderer @"+str(cx)+","+str(cz))
	
	# add to scene
#	call_deferred("add_child", instance)
	add_child(instance)
#	print_debug("added to tree @"+str(cx)+","+str(cz))
	
	# set location
	instance.set_chunk_location(cx, cz)
	
	# set and render chunk
#	print_debug("setting up ChunkRenderer @"+str(cx)+","+str(cz))
	instance.set_chunk(c)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
