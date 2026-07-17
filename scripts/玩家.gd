extends CharacterBody2D

const SPEED := 150.0

@onready var _sprite: AnimatedSprite2D = $玩家贴图

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("左", "右", "上", "下")
	velocity = direction * SPEED
	_update_animation(direction)
	move_and_slide()

func _update_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		_sprite.stop()
		return

	var anim_name: String
	if abs(direction.x) >= abs(direction.y):
		anim_name = "向右走路" if direction.x > 0 else "向左走路"
	else:
		anim_name = "向下走路" if direction.y > 0 else "向上走路"

	if _sprite.animation != anim_name:
		_sprite.play(anim_name)
