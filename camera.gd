extends Camera2D

@onready var player : CharacterBody2D = get_parent()

var left_limit = 0
var left_wall : StaticBody2D = null

func _ready():
	limit_right = 1281
	limit_top = 0
	limit_bottom = 252
	
func _process(_delta):
	_update_camera()
	_build_left_wall()

func _update_camera():
	var width = 480 / 2.0
	if player.position.x >= width:
		left_limit = clamp(left_limit, max(limit_left, player.position.x - width), 1281 - 480)
		limit_left = left_limit
		
func _build_left_wall():
	if player.position.x - left_limit <= 10 && (left_wall == null || left_wall.position.x != left_limit):
		left_wall = StaticBody2D.new()
		left_wall.position = Vector2(left_limit, 100)
		
		var shape = RectangleShape2D.new()
		shape.extents = Vector2(2, 366)

		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shape

		left_wall.add_child(collision_shape)

		get_tree().get_current_scene().add_child(left_wall)
