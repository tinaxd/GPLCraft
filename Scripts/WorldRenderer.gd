extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const ChunkRenderer = preload("res://Scripts/ChunkRenderer.gd")

onready var _chunk_renderer: PackedScene = load("res://Scenes/ChunkRenderer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func render_chunk(c: Chunk) -> void:
	var cx: int = c.cx
	var cz: int = c.cz
	
	# spawn ChunkRenderer
	var instance: ChunkRenderer = _chunk_renderer.instance()
	
	# add to scene
	add_child(instance)
	
	# set location
	instance.set_chunk_location(cx, cz)
	
	# set and render chunk
	instance.set_chunk(c)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
