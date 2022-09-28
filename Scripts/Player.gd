extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal position_update(pos, is_landed)

onready var camera = $Camera

var camera_angle_x: float = 0
var camera_angle_y: float = 0

const gravity_y = -5.0

var survival_mode: bool = true

var velocity: Vector3 = Vector3.ZERO

var main = null # TestMain instance

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	main = get_node("/root/Spatial")

func pointer_lock_check():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	if survival_mode:
		_survival_process(delta)
	else:
		_creative_process(delta)
	
	pointer_lock_check()

func _survival_process(delta: float) -> void:
	# get current chunk
	var cxcz = get_current_chunk()
	var cx = cxcz[0]
	var cz = cxcz[1]
	
	# user input
	var input_velocity =Input.get_vector("move_left","move_right","move_forward","move_back")
	var local_input = Vector3(input_velocity.x, 0, input_velocity.y)
	# conver to velocity in global space
	var global_input = transform.basis.xform(local_input)
	# set y=0
	global_input.y = 0
	# set magnitude
	var svelocity = 10
	global_input = global_input.normalized() * svelocity
	
	var chunk: Chunk = main.world.get_loaded_chunk(cx, cz)
	if chunk == null:
		return
	
	# is_landed check
	var rpos = position_in_chunk()
	var rfx = int(rpos[0])
	var rfy = int(rpos[1])
	var rfz = int(rpos[2])
	var is_landed = false
	if rfy < 0:
		is_landed = true
	else:
		var bottom_block = chunk.get_block_pos(rfx, rfy-1, rfz)
		is_landed = bottom_block.block_id != 0
	
	velocity = global_input
	if is_landed:
		velocity.y = 0
	else:
		velocity += Vector3(0, gravity_y, 0)
	
	emit_signal("position_update", Vector3(cx*Chunk.SIZE_X+rfx, rfy, cz*Chunk.SIZE_Z+rfz), is_landed)
	
	var local_velocity = transform.basis.xform_inv(velocity)
	translate(local_velocity*delta)

func _creative_process(delta: float) -> void:
	var input_velocity =Input.get_vector("move_left","move_right","move_forward","move_back")
	var local_input = Vector3(input_velocity.x, 0, input_velocity.y)
	
	var down_up_velocity = Input.get_axis("move_down", "move_up")
	
	var local_basis = transform.basis
	
	# conver to velocity in global space
	var global_input = local_basis.xform(local_input)
	# set y=0
	global_input.y = 0

	# set magnitude
	var svelocity = 10
	global_input = global_input.normalized() * svelocity * delta
	
	global_input.y = down_up_velocity * svelocity * delta
	
	# convert back to local space
	local_input = local_basis.xform_inv(global_input)
	
	translate(local_input)

func _input(event):
	if event is InputEventMouseMotion:
		var d = event.relative
		
		var y_sensitivity = 0.005
		var x_sensitivity = 0.005
		
		camera_angle_x += x_sensitivity * d.x
		camera_angle_y += y_sensitivity * d.y
		
		if camera_angle_x > PI:
			camera_angle_x -= 2 * PI
		elif camera_angle_x < - PI:
			camera_angle_x += 2 * PI
		
		if camera_angle_y > PI / 2:
			camera_angle_y = PI/2
		elif camera_angle_y < - PI/2:
			camera_angle_y = -PI/2
			
		var x = camera_angle_x
		var y = camera_angle_y
		var target = Vector3(
			cos(y) * sin(x),
			-sin(y),
			-cos(y) * cos(x)
		)
		
		var trans = transform
		target += trans.origin
		var new_trans = trans.looking_at(target, Vector3.UP)
		transform = new_trans

# returns [cx, cz]
func get_current_chunk() -> Array:
	var pos = transform.origin
	var cx = int(pos.x/Chunk.SIZE_X)
	var cz = int(pos.z/Chunk.SIZE_Z)
	return [cx, cz]

# returns [rx, ry, rz]
func position_in_chunk() -> Array:
	var pos = transform.origin
	var rx = fmod(pos.x, Chunk.SIZE_X)
	var ry = pos.y
	var rz = fmod(pos.z, Chunk.SIZE_Z)
	return [rx, ry, rz]

func set_global_position(pos: Vector3) -> void:
	transform.origin = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
