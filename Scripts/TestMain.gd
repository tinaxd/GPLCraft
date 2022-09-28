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
	
	for chunk in chunks:
		w_renderer.render_chunk(chunk)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
