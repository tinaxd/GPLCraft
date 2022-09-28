extends Reference

class_name WorldGen


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var seed_value: int
var perlin: OpenSimplexNoise

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init(seed_v: int):
	self.seed_value = seed_v
	
	perlin = OpenSimplexNoise.new()
	perlin.seed = seed_value
	perlin.octaves = 4
	perlin.period = 20.0
	perlin.persistence = 0.8

# returns Array of int
func _generate_height(cx: int, cz: int) -> Array:
	var noise_values = []
	noise_values.resize(Chunk.SIZE_X * Chunk.SIZE_Z)
	
	for i in range(Chunk.SIZE_X):
		for j in range(Chunk.SIZE_Z):
			var fv = perlin.get_noise_2d(cx + i / float(Chunk.SIZE_X), cz + j / float(Chunk.SIZE_Z))
#			print_debug(fv)
			var v = 64.0 + (fv * 16.0)
			noise_values[j + i*Chunk.SIZE_Z] = int(v)
	
	return noise_values

func generate_chunk(cx: int, cz: int) -> Chunk:
	var heights = _generate_height(cx, cz)
	var c = Chunk.new(cx, cz)
	for i in range(Chunk.SIZE_X):
		for k in range(Chunk.SIZE_Z):
			var height: int = heights[k + i * Chunk.SIZE_Z]
			for j in range(height):
				# dirt block
				var b = Block.new(1)
				c.set_block_pos(i, j, k, b)
	
	return c

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
