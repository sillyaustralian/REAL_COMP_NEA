extends Node2D

@onready var spikes = $"../../spikes"
@onready var large_lava_spike = $"../large_lava_spike"
@onready var area_damage = $"."
@onready var collision_shape_2d = $"../CollisionShape2D"
@onready var static_body_2d = $".."
@onready var cpu_particles_2d = $"../../CPUParticles2D"
@onready var large_spike_top = $"../large_spike_top"
@onready var rock_1 = $"../../rock_1"
@onready var rock_2 = $"../../rock_2"
@onready var rock_3 = $"../../rock_3"

var spin = false
var accel = 50
var accel_x = 40

var lava = false

func _ready():
	if randf() > 0.5:
		spikes.play("large_lava_spike")
		large_lava_spike.visible = true
		large_spike_top.visible = false
		lava = true
	else:
		spikes.play("large_spike")
		large_lava_spike.visible = false
		large_spike_top.visible = true

func damaged():
	if not spin:
		var sfx = randi_range(0, 2)
		if sfx == 0:
			rock_1.play()
		elif sfx == 1:
			rock_2.play()
		else:
			rock_3.play()
		collision_shape_2d.queue_free()
		cpu_particles_2d.emitting = true
		cpu_particles_2d.one_shot = true
		spin = true
		spikes.position.y += 8
		if lava:
			spikes.play("medium_lava_spike")
		else:
			spikes.play("medium_spike")
		await get_tree().create_timer(7).timeout
		queue_free()

func _process(delta):
	if spin:
		accel *= 1.05
		accel_x *= 1.05
		if lava:
			large_lava_spike.rotate(2 * delta)
		else:
			large_spike_top.rotate(2 * delta)
		static_body_2d.position.y += accel * delta
		static_body_2d.position.x += accel_x * delta
