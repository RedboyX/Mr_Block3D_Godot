extends CharacterBody3D

@export var PlayerSpeed : float = 6; ## variavel de velocidade do player
const PLAYERGRAVITY : float = 20.8; ## variavel de gravidade do player
@export var PlayerJumpSpeed : int = 12;
@export var PlayerRunSpeed : float = 12;

@onready var Pivot: Node3D = $"../Pivot";
@onready var mrblock: Node3D = $"MR Block V4"
var rotation_target: Basis;
var cut_jump_height: float = 0.25;

# physics process do player 
func _physics_process(delta: float) -> void:
	PlayerMovement(delta);

	print(PlayerSpeed);
	

# função de movimentação do player
func PlayerMovement(delta:float) -> void:
	var move_direction := Vector3.ZERO;
	move_direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	move_direction.z = Input.get_action_strength("Back") - Input.get_action_strength("Forward")
	move_direction = move_direction.rotated(Vector3.UP, Pivot.rotation.y).normalized();
	
	#Rotação do Modelo
	var turn_dir: Vector3 = self.global_position.direction_to(position - move_direction);
	
	if move_direction: rotation_target = Basis.looking_at(turn_dir)
	mrblock.basis = mrblock.basis.slerp(rotation_target, 1 - exp(delta * 60 * -0.25));
	
	velocity.x = move_direction.x * PlayerSpeed;
	velocity.z = move_direction.z * PlayerSpeed; 
	velocity.y -= PLAYERGRAVITY * delta if Input.is_action_pressed("Jump") else PLAYERGRAVITY * 2.5 * delta;

	if Input.get_action_strength("Run") && is_on_floor():
		PlayerSpeed = lerp(PlayerSpeed, PlayerRunSpeed, 1 - exp(delta * 60 * -.05));
	elif !Input.get_action_strength("Run") && is_on_floor():
		PlayerSpeed = lerp(PlayerSpeed, PlayerRunSpeed /2, 1 - exp(delta * 60 * -.05));

	move_and_slide();

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene();
		
	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y = PlayerJumpSpeed;
	if event.is_action_released("Jump") && velocity.y > 0.0:
		velocity.y *= cut_jump_height;
