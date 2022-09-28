extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const Player = preload("res://Scripts/Player.gd")
const WorldRenderer = preload("res://Scripts/WorldRenderer.gd")

onready var w_renderer: WorldRenderer = get_node("WorldOrigin")
var world: WorldData = null
onready var player: Player = get_node("Player")

var loaded_chunks = [] # array of chunks

var chunk_load_limit_x = 2
var chunk_load_limit_z = 2

var last_chunk_x = 0
var last_chunk_z = 0

var is_chunk_loading = false
var is_chunk_loading_lock: Mutex
var chunk_loading_thread: Thread

# Called when the node enters the scene tree for the first time.
func _ready():
	is_chunk_loading_lock = Mutex.new()
	
	world = WorldData.new(5)

	load_chunk_around(0, 0)
#	var c1 = gen.generate_chunk(0, 1)
#	var c2 = gen.generate_chunk(0, 0)
#	w_renderer.render_chunk(c1)
#	w_renderer.render_chunk(c2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		chunk_load_check()
	
func chunk_load_check() -> void:
	var current_chunk = player.get_current_chunk()
	var cx: int = current_chunk[0]
	var cz: int = current_chunk[1]
	if cx != last_chunk_x or cz != last_chunk_z:
		is_chunk_loading_lock.lock()
		if not is_chunk_loading:
			if chunk_loading_thread != null:
				chunk_loading_thread.wait_to_finish()
			is_chunk_loading = true
			chunk_loading_thread = Thread.new()
			chunk_loading_thread.start(self, "load_chunk_around_async", {
				"cx": cx,
				"cz": cz
			})
		is_chunk_loading_lock.unlock()
		
		last_chunk_x = cx
		last_chunk_z = cz
	
func load_chunk_around(cx: int, cz: int) -> void:
	print_debug("start load_chunk_around("+str(cx)+","+str(cz)+")")
	var x1 = cx - chunk_load_limit_x
	var x2 = cx + chunk_load_limit_x
	var z1 = cz - chunk_load_limit_z
	var z2 = cz + chunk_load_limit_z
	for x in range(x1, x2+1):
		for z in range(z1, z2+1):
			var c = world.load_or_create_chunk(x, z)
			w_renderer.render_chunk(c)
	
	is_chunk_loading_lock.lock()
	is_chunk_loading = false
	is_chunk_loading_lock.unlock()
	print_debug("finish load_chunk_around")

func load_chunk_around_async(userdata):
	load_chunk_around(userdata["cx"], userdata["cz"])
	
func _exit_tree():
	if chunk_loading_thread != null:
		chunk_loading_thread.wait_to_finish()
		chunk_loading_thread = null
