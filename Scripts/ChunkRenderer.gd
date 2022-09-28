extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _chunk: Chunk = null
var _dirty = false

var multimesh: MultiMeshInstance

func set_chunk(c: Chunk) -> void:
	_chunk = c
	_dirty = true
	_render_chunk()

func get_chunk() -> Chunk:
	return _chunk

# Called when the node enters the scene tree for the first time.
func _ready():
	multimesh = MultiMeshInstance.new()
	var mesh = MultiMesh.new()
	multimesh.multimesh = mesh
	mesh.mesh = load("res://Meshes/Cube.tres")
	mesh.transform_format = MultiMesh.TRANSFORM_3D
	
	add_child(multimesh)

func set_chunk_location(cx: int, cz: int) -> void:
	_dirty = true
	var t = Transform.IDENTITY
	var t2 = t.translated(Vector3(cx * Chunk.SIZE_X, 0, cz * Chunk.SIZE_Z))
	transform = t2

func _render_chunk() -> void:
	if _chunk == null:
		return
	if not _dirty:
		return
	
	var dirts = []
	
	for i in range(Chunk.SIZE_X):
		for j in range(Chunk.SIZE_Y):
			for k in range(Chunk.SIZE_Z):
				var b = _chunk.get_block_pos(i, j, k)
				if b.block_id != 0:
					dirts.append(Vector3(i, j, k))
	
	multimesh.multimesh.instance_count = dirts.size()
	
	for i in range(dirts.size()):
		var trans = Transform.IDENTITY
		var position = trans.translated(dirts[i])
		multimesh.multimesh.set_instance_transform(i, position)
	
	_dirty = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
