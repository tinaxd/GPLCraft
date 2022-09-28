extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = $Camera

var camera_angle_x: float = 0
var camera_angle_y: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func pointer_lock_check():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	var input_velocity =Input.get_vector("move_left","move_right","move_forward","move_back")
	var local_input = Vector3(input_velocity.x, 0, input_velocity.y)
	
	var down_up_velocity = Input.get_axis("move_down", "move_up")
	
	var local_basis = transform.basis
	
	# conver to velocity in global space
	var global_input = local_basis.xform(local_input)
	# set y=0
	global_input.y = 0

	# set magnitude
	var velocity = 10
	global_input = global_input.normalized() * velocity * delta
	
	global_input.y = down_up_velocity * velocity * delta
	
	# convert back to local space
	local_input = local_basis.xform_inv(global_input)
	
	translate(local_input)
	
	pointer_lock_check()

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
