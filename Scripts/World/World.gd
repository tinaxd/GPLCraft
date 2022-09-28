extends Reference

class_name WorldData


# Declare member variables here. Examples:
var loaded_chunks: Array = [] # array of Chunk
var _loaded_chunks_lock: Mutex
var gen: WorldGen = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _init(seed_value: int):
	_loaded_chunks_lock = Mutex.new()
	gen = WorldGen.new(seed_value)

func load_or_create_chunk(cx: int, cz: int) -> Chunk:
	_loaded_chunks_lock.lock()
	for _chunk in loaded_chunks:
		var chunk: Chunk = _chunk
		if chunk.cx == cx and chunk.cz == cz:
			_loaded_chunks_lock.unlock()
			return chunk
	_loaded_chunks_lock.unlock()
	
	# if not found
	var c = gen.generate_chunk(cx, cz)
	_loaded_chunks_lock.lock()
	loaded_chunks.append(c)
	_loaded_chunks_lock.unlock()
	return c

func get_loaded_chunk(cx: int, cz: int) -> Chunk:
	_loaded_chunks_lock.lock()
	for _chunk in loaded_chunks:
		var chunk: Chunk = _chunk
		if chunk.cx == cx and chunk.cz == cz:
			_loaded_chunks_lock.unlock()
			return chunk
	_loaded_chunks_lock.unlock()
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
