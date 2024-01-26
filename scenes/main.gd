extends Node

var wave : int
var difficulty : float
const DIFF_MULTIPLIER : float = 1.5
var max_inimigos : int
var lives : int
# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	$GameOver/Button.pressed.connect(new_game)
	
func new_game():
	wave = 1
	lives = 3
	difficulty = 10.0
	max_inimigos = 10
	$MobSpawner/Timer.wait_time = 1.0
	reset()
	
func reset():
	max_inimigos = int(difficulty)
	$Player.reset()
	get_tree().call_group("inimigos", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("items", "queue_free")
	$Hud/LifeLabel.text = "X " + str(lives)
	$Hud/WaveLabel.text = "WAVE: " + str(wave)
	$Hud/EnimiesLabel.text = "X " + str(max_inimigos)
	$GameOver.hide()
	get_tree().paused = false
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_wave_completed():
		wave += 1
		#dificuldade
		difficulty *= DIFF_MULTIPLIER
		if $MobSpawner/Timer.wait_time > 0.25:
			$MobSpawner/Timer.wait_time -= 0.08
		get_tree().paused = true
		$WaveOverTimer.start()


func _on_mob_spawner_hit_p():
	lives -= 1
	$Hud/LifeLabel.text = "X " + str(lives)
	if lives <= 0:
		get_tree().paused = true
		$GameOver/WaveSurvivedLabel.text = "WAVES SURVIVED: " + str(wave - 1)
		$GameOver.show()
	else:
		$WaveOverTimer.start()
		
func _on_wave_over_timer_timeout():
	reset()
		
		
func is_wave_completed():
	var all_dead = true
	var enemies = get_tree().get_nodes_in_group("inimigos")
	#checkagem
	if enemies.size() == max_inimigos:
		for e in enemies:
			if e.alive:
				all_dead = false
		return all_dead
	else:
		return false
	



