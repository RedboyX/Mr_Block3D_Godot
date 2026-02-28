extends Node3D
@onready var mr_block: CharacterBody3D = $"../MrBlock"
var catchmouse : bool = true;
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@export var Sense : float = 0.005;

func _process(delta: float) -> void:
	global_position = lerp(global_position, mr_block.global_position + Vector3(0,1,0), 1 - exp(delta * 60 * -.25)) 
	CameraInputControl(delta);
	
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		catchmouse = !catchmouse
		if catchmouse :
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * Sense);
		spring_arm_3d.rotate_x(event.relative.y * Sense);
		spring_arm_3d.rotation_degrees.x = clamp(spring_arm_3d.rotation_degrees.x, -80, 80);
func CameraInputControl(delta):
	rotation.y += Input.get_axis("Camera Left","Camera Right") * (Sense * 10) * delta * 60;
	spring_arm_3d.rotation.x += Input.get_axis("CameraBack","CameraForward") * (Sense * 10) * delta * 60;
	spring_arm_3d.rotation_degrees.x = clamp(spring_arm_3d.rotation_degrees.x, -80, 80);
