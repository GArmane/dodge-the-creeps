extends Node


export (PackedScene) var Mob
var score


# Game handling
func game_over():
	$MusicPlayer.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()


func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$MusicPlayer.play()
	$StartTimer.start()
	$Player.start($StartPosition.position)


# Signal handling
func _on_HUD_start_game():
	new_game()


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

	$HUD.connect("start_game", mob, "_on_start_game")


func _on_Player_hit():
	game_over()


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


# Callbacks
func _ready():
	randomize()
