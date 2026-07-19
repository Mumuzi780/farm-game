extends CharacterBody2D

const SPEED := 150.0
const ACCELERATION := 1200.0
const FRICTION := 1000.0

@onready var _sprite: AnimatedSprite2D = $玩家贴图
@onready var _camera: Camera2D = $摄像机
@onready var _area: CollisionShape2D = $"../楼梯/上碰撞"
@onready var _monitor_up : Area2D = $"../检测上楼"
@onready var _monitor_down : Area2D = $"../检测下楼"
@onready var _louti : CollisionShape2D = $"../../第二层地图/第二层草地碰撞箱/楼梯上边竖条"

var is_up = -1 # 玩家是否触碰楼梯上楼
var is_stair = 1 #检测玩家是否处于上楼梯阶段

func _ready() -> void:
	_camera.position_smoothing_enabled = true
	_camera.position_smoothing_speed = 5.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("左", "右", "上", "下")
	
		# === 新增：楼梯对角线移动 ===
	if is_stair > 0 and direction != Vector2.ZERO:
		direction.y -= direction.x          # 右移附带向上，左移附带向下
		direction = direction.normalized()  # 保持单位向量
	# ==========================
	
	var target_velocity := direction * SPEED
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
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
	
	
func _on_up_body_entered(body: Node2D) -> void:
	is_up = -1 * is_up
	is_stair = -1 * is_stair
	
	if is_up > 0:
		_area.rotation = -deg_to_rad(45)
		z_index = 15
		_louti.shape.b = Vector2(0.0,160.0)
	else:
		_area.rotation = -deg_to_rad(0)
		z_index = 5
		_louti.shape.b = Vector2(0.0,190.0)

func _on_up_body_exited(body: Node2D) -> void:
	pass


func _on_down_body_entered(body: Node2D) -> void:
	is_stair = -1 * is_stair
