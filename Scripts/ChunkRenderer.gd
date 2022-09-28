extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var block_material = load("res://Materials/BlockMaterial.tres")

var _chunk: Chunk = null
var _dirty = false

var mesh_instance: MeshInstance

func set_chunk(c: Chunk) -> void:
	_chunk = c
	_dirty = true
	_render_chunk()

func get_chunk() -> Chunk:
	return _chunk

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh_instance = MeshInstance.new()
	
	add_child(mesh_instance)

func set_chunk_location(cx: int, cz: int) -> void:
	_dirty = true
	var t = Transform.IDENTITY
	var t2 = t.translated(Vector3(cx * Chunk.SIZE_X, 0, cz * Chunk.SIZE_Z))
	transform = t2

enum {XPOSF=1, XNEGF=2, YPOSF=4, YNEGF=8, ZPOSF=16, ZNEGF=32}

static func _av(st: SurfaceTool, x: int, y: int, z: int, bx: int, by: int, bz: int, normal: Vector3, ux: int, uy: int, tx: int, ty: int) -> void:
	var uxf = (16.0/256.0) * (tx + ux)
	var uyf = (16.0/256.0) * (ty + uy)
	st.add_uv(Vector2(uxf, uyf))
	st.add_normal(normal)
	st.add_vertex(Vector3(x+bx, y+by, z+bz))

static func _add_face(s: SurfaceTool, face: int, x: int, y: int,z: int)->void:
	match face:
		XPOSF:
			var norm = Vector3(1, 0, 0)
			_av(s, 1, 0, 1, x, y, z, norm, 0, 1, 0, 15)
			_av(s, 1, 1, 1, x, y, z, norm, 0, 0, 0, 15)
			_av(s, 1, 1, 0, x, y, z, norm, 1, 0, 0, 15)
			
			_av(s, 1, 1, 0, x, y, z, norm, 1, 0, 0, 15)
			_av(s, 1, 0, 0, x, y, z, norm, 1, 1, 0, 15)
			_av(s, 1, 0, 1, x, y, z, norm, 0, 1, 0, 15)
		YNEGF:
			var norm = Vector3(0, -1, 0)
			_av(s, 0, 0, 1, x, y, z, norm, 1, 0, 2, 15)
			_av(s, 1, 0, 1, x, y, z, norm, 1, 1, 2, 15)
			_av(s, 1, 0, 0, x, y, z, norm, 0, 1, 2, 15)
			
			_av(s, 1, 0, 0, x, y, z, norm, 0, 1, 2, 15)
			_av(s, 0, 0, 0, x, y, z, norm, 0, 0, 2, 15)
			_av(s, 0, 0, 1, x, y, z, norm, 1, 0, 2, 15)
		XNEGF:
			var norm = Vector3(-1, 0, 0)
			_av(s, 0, 1, 1, x, y, z, norm, 1, 0, 0, 15)
			_av(s, 0, 0, 1, x, y, z, norm, 1, 1, 0, 15)
			_av(s, 0, 0, 0, x, y, z, norm, 0, 1, 0, 15)
			
			_av(s, 0, 0, 0, x, y, z, norm, 0, 1, 0, 15)
			_av(s, 0, 1, 0, x, y, z, norm, 0, 0, 0, 15)
			_av(s, 0, 1, 1, x, y, z, norm, 1, 0, 0, 15)
		YPOSF:
			var norm = Vector3(0, 1, 0)
			_av(s, 1, 1, 1, x, y, z, norm, 1, 0, 1, 15)
			_av(s, 0, 1, 1, x, y, z, norm, 1, 1, 1, 15)
			_av(s, 0, 1, 0, x, y, z, norm, 0, 1, 1, 15)
			
			_av(s, 0, 1, 0, x, y, z, norm, 0, 1, 1, 15)
			_av(s, 1, 1, 0, x, y, z, norm, 0, 0, 1, 15)
			_av(s, 1, 1, 1, x, y, z, norm, 1, 0, 1, 15)
		ZPOSF:
			var norm = Vector3(0, 0, 1)
			_av(s, 0, 1, 1, x, y, z, norm, 0, 0, 0, 15)
			_av(s, 1, 1, 1, x, y, z, norm, 1, 0, 0, 15)
			_av(s, 1, 0, 1, x, y, z, norm, 1, 1, 0, 15)
			
			_av(s, 1, 0, 1, x, y, z, norm, 1, 1, 0, 15)
			_av(s, 0, 0, 1, x, y, z, norm, 0, 1, 0, 15)
			_av(s, 0, 1, 1, x, y, z, norm, 0, 0, 0, 15)
		ZNEGF:
			var norm = Vector3(0, 0, -1)
			_av(s, 0, 0, 0, x, y, z, norm, 1, 1, 0, 15)
			_av(s, 1, 0, 0, x, y, z, norm, 0, 1, 0, 15)
			_av(s, 1, 1, 0, x, y, z, norm, 0, 0, 0, 15)
			
			_av(s, 1, 1, 0, x, y, z, norm, 0, 0, 0, 15)
			_av(s, 0, 1, 0, x, y, z, norm, 1, 0, 0, 15)
			_av(s, 0, 0, 0, x, y, z, norm, 1, 1, 0, 15)

static func _add_faces(st: SurfaceTool, faces: int, x: int, y: int,z: int) -> void:
	if faces & XNEGF != 0:
		_add_face(st, XNEGF, x, y, z)
	if faces & XPOSF != 0:
		_add_face(st, XPOSF, x, y, z)
	if faces & YNEGF != 0:
		_add_face(st, YNEGF, x, y, z)
	if faces & YPOSF != 0:
		_add_face(st, YPOSF, x, y, z)
	if faces & ZNEGF != 0:
		_add_face(st, ZNEGF, x, y, z)
	if faces & ZPOSF != 0:
		_add_face(st, ZPOSF, x, y, z)

const ALL_FACES = XNEGF | XPOSF | YNEGF | YPOSF | ZNEGF | ZPOSF

func _block_exists(x: int, y: int, z: int) -> bool:
	if x < 0 or x >= Chunk.SIZE_X or y < 0 or y >= Chunk.SIZE_Y or z < 0 or z >= Chunk.SIZE_Z:
		return false
	
	var b: Block = _chunk.get_block_pos(x, y, z)
	return b.block_id != 0

func _generate_mesh() -> Mesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(Chunk.SIZE_X):
		for j in range(Chunk.SIZE_Y):
			for k in range(Chunk.SIZE_Z):
				var block: Block = _chunk.get_block_pos(i, j, k)
				if block.block_id == 0:
					# air block
					continue
					
				var faces = ALL_FACES
				if _block_exists(i-1, j, k):
					faces &= ~XNEGF
				if _block_exists(i+1, j, k):
					faces &= ~XPOSF
				if _block_exists(i, j-1, k):
					faces &= ~YNEGF
				if _block_exists(i, j+1, k):
					faces &= ~YPOSF
				if _block_exists(i, j, k-1):
					faces &= ~ZNEGF
				if _block_exists(i, j, k+1):
					faces &= ~ZPOSF
				_add_faces(st, faces, i, j, k)
	return st.commit()

func _render_chunk() -> void:
	if _chunk == null:
		return
	if not _dirty:
		return
	
	var mesh = _generate_mesh()
	
	mesh_instance.mesh = mesh
	mesh_instance.material_override = block_material
	
	_dirty = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
