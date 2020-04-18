extends Node


export (PackedScene) var Mob
var score


# Game handling
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()


# Signal handling
func _on_ScoreTimer_timeout():
	score += 1


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()

	var mob = Mob.instance()
	add_child(mob)

	var direction = (
		$MobPath/MobSpawnLocation.rotation
		+ (PI / 2)
		+ rand_range(-PI / 4, PI / 4)
	)
	mob.position = $MobPath/MobSpawnLocation.position
	mob.rotation = direction

	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)


# Callbacks
func _ready():
	randomize()
