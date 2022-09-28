extends Reference

class_name WorldData


# Declare member variables here. Examples:
var loaded_chunks: Array = [] # array of Chunk
var gen: WorldGen = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _init(seed_value: int):
	gen = WorldGen.new(seed_value)

func load_or_create_chunk(cx: int, cz: int) -> Chunk:
	for _chunk in loaded_chunks:
		var chunk: Chunk = _chunk
		if chunk.cx == cx and chunk.cz == cz:
			return chunk
	
	# if not found
	var c = gen.generate_chunk(cx, cz)
	loaded_chunks.append(c)
	return c

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
