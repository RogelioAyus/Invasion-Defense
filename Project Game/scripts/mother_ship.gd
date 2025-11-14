extends CharacterBody2D

@onready var buttonList = [%"0", %"1", %"2", %"3", %"4", %"5",%"6",%"7",%"8"]
@onready var shopPlayerAn = $motherShipLayer/shopPlayerAn
@onready var boss_hit = $BossHit


var SPEED = 200
@export var limitSpeed = 300
var ghost_trail = preload("res://TSCN Scenes/ghost_trail.tscn")

var axis = Vector2.ZERO;
var turn = 0;
var degreew = 0;
var start_engine_delay = 1;

var bossKnock = 0;
var angleKnock = 0;

#dash info
var onCooldown = false;
var cooldown = 0;
var dashDur = 0;



		
func _ready():
	self.add_to_group("_base")
	
func dashingTrail():
	var trail = ghost_trail.instantiate()
	trail.position = self.position
	trail.rotation = $Mothership.rotation
	get_tree().get_root().add_child(trail)
	
func _physics_process(delta):
	GlobalScript.shipDashCooldown = cooldown
	
	#in Dash cooldown and duration sequence
	if cooldown > 0:
		limitSpeed = 300
		cooldown -= delta
		if cooldown < 0:
			cooldown = 0 #set to zero and wait for isDashing again
			onCooldown = false
			#print("cooldown done")
		#print("cooldown")
			
	elif dashDur > 0: #dashing comencing
		dashDur -= delta
		limitSpeed = 1500
		SPEED = 99999
		dashingTrail()
		if dashDur < 0:
			SPEED = 200
			cooldown = 7
	elif Input.is_action_just_pressed("shift"):
		onCooldown = true
		dashDur = 0.6
		$dashOGG.play()

		
	$Shield.self_modulate = Color(1,1,1,1 if GlobalScript.shipShieldHealth >= 1 else 0)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	axis.x = (int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")))
	axis.y = (int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up")))
	if bossKnock > 0:
		bossKnock -= delta
		velocity = Vector2(-cos(angleKnock)*1500*bossKnock,sin(angleKnock)*1500*bossKnock)
		
	if axis and bossKnock <= 0:
		start_engine_delay += delta
		#velocity.x += axis.x * SPEED*delta
		#velocity.y += axis.y * SPEED*delta
		#velocity.x = max(min(velocity.x,limitSpeed ),-limitSpeed )
		#velocity.y = max(min(velocity.y,limitSpeed ),-limitSpeed )
		velocity.x += axis.x * SPEED *delta
		velocity.y += axis.y * SPEED *delta
		velocity.x = max(min(velocity.x,limitSpeed),-abs(limitSpeed))
		velocity.y = max(min(velocity.y,limitSpeed),-abs(limitSpeed))
	else:
		start_engine_delay -= delta
	start_engine_delay = max(min(start_engine_delay,1),0)
	
	$Mothership/GPUParticles2D.self_modulate = Color(1,1,1,max(min(start_engine_delay,1),0))
	velocity.x = move_toward(velocity.x, 0, 1+abs(velocity.x)/200)
	velocity.y = move_toward(velocity.y, 0, 1+abs(velocity.y)/200)
	$Mothership/GPUParticles2D.process_material.initial_velocity_max = max(min(abs(velocity.x)*20 if abs(velocity.x) >= abs(velocity.y) else abs(velocity.y)*20 ,3000),0)
	
	

	
	degreew = atan2(velocity.y,velocity.x)
	if axis or velocity.y >= 10 or velocity.x >= 10:
		$Mothership.rotation= degreew + 1.58

	move_and_slide()

func _process(_delta):
	$motherShipLayer/shop.disabled = GlobalScript.isPressedShop
	


func _on_ship_2d_area_entered(area):
	var parent = area.get_parent()
	if parent.get("boss"):
		var dirt = (parent.position - self.position).normalized()
		angleKnock = atan2(dirt.y,dirt.x)
		bossKnock = 1
		boss_hit.play()
		if GlobalScript.shipShieldHealth <= 0:
			GlobalScript.shiphealth -= 15;
		else:
			GlobalScript.shipShieldHealth -= GlobalScript.shipShieldHealth
			GlobalScript.isHitOnShip = true
			GlobalScript.shipShieldRegenDelay = GlobalScript.shipShieldRegenDelayMax
		
	elif area.name == "enemy_area":
		$hurt.play()
		if GlobalScript.shipShieldHealth <= 0:
			GlobalScript.shiphealth -= 1;
			$Mothership/FlashHurt.play("RESET")
			$Mothership/FlashHurt.play("Hurt")
		else:
			$Shield/shieldAnimation.stop(false)
			GlobalScript.shipShieldHealth -= 1;
			GlobalScript.isHitOnShip = true
			GlobalScript.shipShieldRegenDelay = GlobalScript.shipShieldRegenDelayMax
			if GlobalScript.shipShieldHealth != 0:
				$Shield/shieldAnimation.play("Hit")
				
func _on_shop_pressed():
	get_tree().paused = true
	GlobalScript.isPaused = true
	GlobalScript.isPressedShop = true
	shopPlayerAn.play("shopOpen")
	for i in buttonList:
		i.button.disabled = false;
	$"..".buttonupdate($"..".bST)
	
	
func gotDamage(damage = 1):
	$hurt.play()
	if GlobalScript.shipShieldHealth <= 0:
			GlobalScript.shiphealth -= damage;
			if GlobalScript.shiphealth < 0:
				GlobalScript.shiphealth = 0
			$Mothership/FlashHurt.play("RESET")
			$Mothership/FlashHurt.play("Hurt")
	else:
		GlobalScript.shipShieldHealth -= damage
		GlobalScript.isHitOnShip = true
		GlobalScript.shipShieldRegenDelay = GlobalScript.shipShieldRegenDelayMax
		if GlobalScript.shipShieldHealth != 0:
			$Shield/shieldAnimation.play("Hit")
