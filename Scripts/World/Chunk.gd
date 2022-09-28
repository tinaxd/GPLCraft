extends Reference


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name Chunk

const SIZE_X = 16
const SIZE_Y = 128
const SIZE_Z = 16

const Block = preload('res://Scripts/World/Block.gd')

var cx: int
var cz: int
var blocks: Array # array of blocks

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init(cx_v: int, cz_v: int):
	self.cx = cx_v
	self.cz = cz_v
	
	# initialize with air blocks
	for _i in range(SIZE_X*SIZE_Y*SIZE_Z):
		var b = Block.new(0)
		blocks.append(b)

static func index(rx: int, ry: int, rz: int) -> int:
	return rx + rz * SIZE_X + ry * (SIZE_X * SIZE_Z)

func set_block_idx(idx: int, blk: Block) -> void:
	blocks[idx] = blk
	
func get_block_idx(idx: int) -> Block:
	return blocks[idx]

func set_block_pos(rx: int, ry: int, rz: int, blk: Block) -> void:
	set_block_idx(index(rx, ry, rz), blk)

func get_block_pos(rx: int, ry: int, rz: int) -> Block:
	return get_block_idx(index(rx, ry, rz))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
