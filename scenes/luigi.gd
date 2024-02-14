extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: ShapeCast2D = $ShapeCast2D
@export var damping = 0.05
var swipe_started = false
var swipe_start = Vector2()
@export var minimum_drag = 5
@export var speed:float = 6
var collided = false

var tilemap
var collision
var cell
var tileID

func _ready():
	anim.play("default")
	tilemap = get_parent().get_node("TileMap")
	
func _process(delta):
	if(area.is_colliding()):
		if(area.get_collider(0) is TileMap):
			print("booboo")
			cell = tilemap.local_to_map(area.get_collision_point(0) - area.get_collision_normal(0))
			print(area.get_collision_point(0))
			print(area.get_collision_normal(0))
			tilemap.set_cell(0, cell, -1)
			

func _input(event):
	if event.is_action_pressed("press"):
		swipe_started = true
		swipe_start = get_global_mouse_position()
	if event.is_action_released("press") and swipe_started:
		swipe_started = false
		var swipe_end = get_global_mouse_position()
		var swipe = swipe_end - swipe_start
		if swipe.length() > minimum_drag:
			velocity = swipe * speed

func _physics_process(delta):
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, damping)
	rotation = velocity.angle()


