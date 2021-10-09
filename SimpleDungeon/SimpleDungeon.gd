extends Node2D

export var width := 100
export var height := 100
export var maxWidth := 40
export var maxHeight := 40
export var minWidth := 1
export var minHeight:= 1

export var tries := 100
export var extraCorridors:=30

export(PackedScene) var colision_node
export(PackedScene) var floor_node

var map := []
var random
var rectArray := []

# Called when the node enters the scene tree for the first time.
func _start():
	map.resize(width)
	for i in width:
		map[i] = []
		map[i].resize(height)
		for j in height:
			map[i][j] = 0
	
	_generate()
	_create_corridors()
	_create_dungeon()
	pass # Replace with function body.



func _create_dungeon():
	for i in width:
		for j in height:
			if (map[i][j] == 0):
				var node = colision_node.instance()
				node.position = Vector2(i*node.get_node("icon").texture.get_width(), j * node.get_node("icon").texture.get_height())
				node.name = "col" 
				node.modulate = Color(random.randf_range(0,1), random.randf_range(0,1), random.randf_range(0,1))
				add_child(node)

	for j in range(-1, height+1): 
		var node = colision_node.instance()
		node.position = Vector2(-1*node.get_node("icon").texture.get_width(), j * node.get_node("icon").texture.get_height())
		node.name = "col" 
		#node.modulate = Color(random.randf_range(0,1), random.randf_range(0,1), random.randf_range(0,1))
		add_child(node)

	for j in range(-1, height+1): 
		var node = colision_node.instance()
		node.position = Vector2((width)*node.get_node("icon").texture.get_width(), j * node.get_node("icon").texture.get_height())
		node.name = "col" 
		#node.modulate = Color(random.randf_range(0,1), random.randf_range(0,1), random.randf_range(0,1))
		add_child(node)

	for j in width:
		var node = colision_node.instance()
		node.position = Vector2(j*node.get_node("icon").texture.get_width(), (height) * node.get_node("icon").texture.get_height())
		node.name = "col" 
		#node.modulate = Color(random.randf_range(0,1), random.randf_range(0,1), random.randf_range(0,1))
		add_child(node)
	
	for j in width:
		var node = colision_node.instance()
		node.position = Vector2(j*node.get_node("icon").texture.get_width(), -1* node.get_node("icon").texture.get_height())
		node.name = "col" 
		#node.modulate = Color(random.randf_range(0,1), random.randf_range(0,1), random.randf_range(0,1))
		add_child(node)

	pass

func _create_corridors():
	for i in rectArray.size()-1:
		var rect0 = rectArray[i]
		var rect1 = rectArray[i+1]
		var x0 =  random.randi_range(rect0.position.x, rect0.position.x + rect0.size.x-1)
		var y0 = random.randi_range(rect0.position.y, rect0.position.y + rect0.size.y-1)
		var x1 = random.randi_range(rect1.position.x, rect1.position.x + rect1.size.x-1)
		var y1 = random.randi_range(rect1.position.y, rect1.position.y + rect1.size.y-1)
		_create_corridor_between(x0, y0, x1, y1)
	
	for i in extraCorridors:
		var rect0 = rectArray[random.randi_range(0, rectArray.size()-1)]
		var rect1 = rectArray[random.randi_range(0, rectArray.size()-1)]
		var x0 =  random.randi_range(rect0.position.x, rect0.position.x + rect0.size.x-1)
		var y0 = random.randi_range(rect0.position.y, rect0.position.y + rect0.size.y-1)
		var x1 = random.randi_range(rect1.position.x, rect1.position.x + rect1.size.x-1)
		var y1 = random.randi_range(rect1.position.y, rect1.position.y + rect1.size.y-1)
		_create_corridor_between(x0, y0, x1, y1)

	pass

func _create_corridor_between(x0:int, y0:int, x1:int, y1:int ):
	var xFactor:= x1 - x0
	if xFactor > 0 :
		 xFactor = 1 
	elif xFactor < 0 :  
		xFactor = -1
	else:
		xFactor = 0

	var yFactor:= y1 - y0
	if yFactor > 0 :
		yFactor = 1
	elif (yFactor < 0):  
		yFactor = -1
	else: 
		yFactor = 0
	
	var j = y0

	while (j != y1):
		map[x0][j] = 1
		map[x0+xFactor][j] = 1
		j += yFactor
	var i = x0
	while (i!= x1):
		map[i][j] = 1
		map[i][j+yFactor] = 1
		i += xFactor

	pass



func _generate():
	random = RandomNumberGenerator.new()
	random.randomize()
	print(random.seed)
	for i in tries:
		var newWidth = random.randi_range(minWidth, maxWidth)
		var newHeight =random.randi_range(minHeight, maxHeight)
		var newX = random.randi_range(2, width - newWidth-2)
		var newY = random.randi_range(2, height - newHeight-2)
		var rect = Rect2(newX, newY, newWidth, newHeight)
		var canBeAdded := true
		for j in rectArray:
			if (j.intersects(rect)):
				canBeAdded = false
				break
		if (canBeAdded):
			rectArray.append(rect)
			for k in range(newX,(newX + newWidth)):
				for l in range (newY, newY + newHeight):
					map[k][l] = 1
		
		



	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
