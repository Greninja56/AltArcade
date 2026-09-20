extends Node

const PORT := 10000

const POS_RANGE := .95        
const SMOOTH := 20.0          
const DEADZONE := 0.01        
const LOCK_THRESHOLD := 0.08  
const AXES := ["x", "y", "z"]

var udp := PacketPeerUDP.new()
var pos := 0.0                
var connected := false

var last_packet_ms := 0
var grav := Vector3.ZERO
var center := Vector3.ZERO
var centered := false
var axis_idx := -1            
var flip := -1.0               
var target_pos := 0.0

func _ready():
	if udp.bind(PORT) != OK:
		push_error("Could not bind UDP port %d" % PORT)

func _process(delta):
	while udp.get_available_packet_count() > 0:
		var text = udp.get_packet().get_string_from_utf8()
		var data = JSON.parse_string(text)
		if data is Dictionary and data.has("sensordata"):
			handle(data["sensordata"])

	connected = Time.get_ticks_msec() - last_packet_ms < 500
	pos = lerp(pos, target_pos, 1.0 - exp(-SMOOTH * delta))

func handle(s):
	last_packet_ms = Time.get_ticks_msec()
	if not s.has("gravity"):
		return
	var g = s["gravity"]
	grav = Vector3(g["x"], g["y"], g["z"])

	if not centered:
		center = grav
		centered = true

	var d = grav - center

	if axis_idx == -1:
		var m = d.abs()
		var i = m.max_axis_index()
		if m[i] > LOCK_THRESHOLD:
			axis_idx = i
			print("Locked tilt axis: ", AXES[i])
		else:
			target_pos = 0.0
			return

	var t = d[axis_idx] * flip
	if abs(t) < DEADZONE:
		t = 0.0
	target_pos = clamp(t / POS_RANGE, -1.0, 1.0)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_C:
			center = grav
			axis_idx = -1
			target_pos = 0.0
		elif event.keycode == KEY_F:
			flip = -flip
