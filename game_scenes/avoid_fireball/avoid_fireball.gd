extends Node

@export var fireball_template: CollisionObject2D
@onready var fireball_spawnerO: PathFollow2D = $"2D/BGBottom/PathFireballSpawner/FireballSpawnpointO"
@onready var fireball_spawnerF: PathFollow2D = $"2D/BGBottom/PathFireballSpawner/FireballSpawnpointF"
@onready var fireball_container: CanvasGroup = $"2D/BGBottom/PathFireballSpawner/ScreenMask/CanvasGroup"

var going: bool = true

func _ready() -> void:
	randomize()


func _physics_process(delta: float) -> void:
	if not Engine.get_process_frames() % 16 and going:
		fireball_spawnerO.progress_ratio = randf()
		fireball_spawnerF.progress_ratio = fireball_spawnerO.progress_ratio + randf_range(0.3, 0.7)
		var new_fball: CollisionObject2D = fireball_template.duplicate()
		new_fball.position = fireball_spawnerO.position

		var new_fball_dir: float = fireball_spawnerO.position.angle_to_point(fireball_spawnerF.position)
		new_fball.direction_angle = new_fball_dir

		new_fball.process_mode = Node.PROCESS_MODE_INHERIT
		fireball_container.add_child(new_fball)
		fireball_container.move_child(new_fball, 0)


func _on_bobomb_detonated() -> void:
	going = false
	$AudioMusic.volume_db = -8
	$HUDOverlay.auto_score_increase = 0
	$ResultsOverlay.calc_and_store_scoreboard($HUDOverlay.points)
	$ResultsOverlay.appear()
