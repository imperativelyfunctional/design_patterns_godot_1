extends CharacterBody2D

@export var speed = 80

@onready var sprite = $Sprite2D

@onready var playback : AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_ladder : bool = false
var can_move_horizontally : bool = true
var can_move_vertically : bool = true
var falling : bool = false

func _ready():
	EventBus.connect('entering_ladder', Callable(self, '_climb_ladder'))
	EventBus.connect('leaving_ladder',  Callable(self, '_exit_ladder'))
	EventBus.connect('falling',  Callable(self, '_falling'))
	EventBus.connect('landing',  Callable(self, '_landing'))

func _falling():
	can_move_horizontally = false
	can_move_vertically = false
	falling = true

func _landing():
	can_move_horizontally = true
	can_move_vertically = true
	falling = false
		
func _climb_ladder(p, d: Vector2):
	on_ladder = true
	can_move_horizontally = false
	if !falling:
		global_position.x = d.x / 2 + p.x - 7;

func _exit_ladder(_p, _d):
	can_move_horizontally = true
	on_ladder = false
	
func _physics_process(_delta):
	var _velocity = Vector2.ZERO

	if can_move_horizontally:
		if Input.is_action_pressed("UI_RIGHT"):
			_velocity.x = 1
			sprite.flip_h = false
		if Input.is_action_pressed("UI_LEFT"):
			_velocity.x = -1
			sprite.flip_h = true
	
	if can_move_vertically:
		if Input.is_action_pressed("UI_DOWN"):
			_velocity.y = 1
		if Input.is_action_pressed("UI_UP"):
			_velocity.y = -1
	if !falling:
		velocity = _velocity.normalized() * speed
	
	if falling:
		velocity.y += gravity * _delta
		velocity.x = 0
		
	if falling:
		playback.travel('falling')
	elif velocity == Vector2.ZERO && on_ladder:
		playback.travel("idling_on_ladder")
	elif velocity == Vector2.ZERO:
		playback.travel("idling")
	elif on_ladder:
		playback.travel("climbing")
	elif velocity.x != 0 && velocity.y < 0:
		playback.travel("walking_up")
	else:
		playback.travel("walking")
	move_and_slide()
