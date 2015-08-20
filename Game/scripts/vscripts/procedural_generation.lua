require('util')
require('physics')
require('timers')

room_length_unit = 20
unit = 128

Physics:CreateColliderProfile("spawner", 
  {
    type = COLLIDER_SPHERE,
    draw = true,
    -- box = {Vector(0,0,128), Vector(2000,2000,2000)},
    radius = 128,
    recollideTime = 0,
    skipFrames = 0,
    spawnLocation = Vector(0, 0, 0),
    attachment = nil,
    test = function(self, collider, collided)
      return collided.IsRealHero and collided:IsRealHero()
    end,
    action = function(self, box, unit)
    	print("hit the collider for surw")
    	print(self.spawnLocation)
    	print('testing ')
    	print(math.random())


		CreateUnitByName('earth_dude', self.spawnLocation, true, nil, nil, 1)
		if self.attachment then
			print('removing self')
			self.attachment:RemoveSelf()
		end


    	-- delete the collider
    	Physics:RemoveCollider(self.name)
    end
	})


Physics:CreateColliderProfile("spawnerAA", 
  {
    type = COLLIDER_AABOX,
    draw = true,
    box = {Vector(0,0,128), Vector(2000,2000,2000)},
    recollideTime = 0,
    skipFrames = 0,
    spawnLocation = Vector(0, 0, 0),
    test = function(self, collided)
      return collided.IsRealHero and collided:IsRealHero()
    end,
    action = function(self, box, unit)
    	print("hit the collider for surw")
    	print(self.spawnLocation)

    	-- delete the collider
    	Physics:RemoveCollider(self.name)
    end
	})


function generate_rooms()
	print("Yay hit here!\n\n\n\n")
	startX = 0 - room_length_unit / 2
	startY = 0 - room_length_unit / 2

	collider = Physics:ColliderFromProfile('spawnerAA')

	Physics:AddCollider('testCollider', collider)

	-- create_wall_at_point(0,0)
	-- create_wall_at_point(0,1	)
	-- create_wall_at_point(0,2)
	-- for y=-room_length_unit/2, room_length_unit,1 do
	-- 	for x=-room_length_unit/2, room_length_unit,1 do
	-- 		create_wall_at_point(x*unit, y*unit)
	-- 	end
	-- end
	create_square_room_centered_at_point(0 * unit, 0 * unit)
end


function create_square_room_centered_at_point(x,y)
	print('Creating room')
	startX = x - unit * room_length_unit / 2 
	endX = startX + unit * room_length_unit
	startY = y - unit * room_length_unit / 2 
	endY = startY + unit * room_length_unit
	spawnLocation = Vector(x, y, 128)

	-- create top wall
	for x=0, room_length_unit, 1 do
		if (x == room_length_unit / 2) then
			create_door_at_point(startX + x*unit, startY, nil, true, true, spawnLocation)
		else 
			create_wall_at_point(startX + x*unit, startY, nil, true, true)
		end

		print('top')
	end

	-- create left and right wall
	for y=1, room_length_unit - 1, 1 do 
		if (y == room_length_unit / 2) then
			create_door_at_point(startX, startY + y * unit, nil, false, true, spawnLocation)
			create_door_at_point(endX, startY + y * unit, nil, false, true, spawnLocation)
		else
			create_wall_at_point(startX, startY + y * unit, nil, false)
			create_wall_at_point(endX, startY + y * unit, nil, false)
		end
	end

	-- create bottom wall
	for x=0, room_length_unit, 1 do
		print('bottom')
		if (x == room_length_unit / 2) then
			create_door_at_point(startX + x*unit, endY, nil, true, true, spawnLocation)
		else
			create_wall_at_point(startX + x*unit, endY, nil, true, true)
		end
	end

end

function create_door_at_point(x, y, model, horizontal, shouldSpawn, vectorSpawnLocation)
	print('creating gate')
	shouldSpawn = shouldSpawn or true
	model = model or "models/props_structures/gate_entrance002.vmdl"
	gate_door = CreateUnitByName('gate_door', Vector(x, y, 256), false, nil, nil, 1)
	if horizontal then
		Timers:CreateTimer(function()		
				print('rottattt')
				gate_door:SetForwardVector(Vector(12098.0, 12000.0, 120333.0))
				return nil
			end
		)	
	end


	if shouldSpawn then
		-- set up spawner on door
		Physics:Unit(gate_door)
		gate_door:AddColliderFromProfile('spawner', {
			spawnLocation = vectorSpawnLocation,
			attachment = gate_door,
		})
		print('created gate')
	end

end

function create_wall_at_point(x, y, model, horizontal) 
	model = model or 'models/props_garden/bad_stonewall002.vmdl'

	if horizontal then
		rotationAngle = Vector(0, 90, 0) 
	else
		rotationAngle = Vector(0, 0, 0)
	end
	print(rotationAngle)

	entity = SpawnEntityFromTableSynchronous('point_simple_obstruction', 
		{
			origin = Vector(x, y, 128),
			block_fow = true
		}) 

	dyna = SpawnEntityFromTableSynchronous('prop_dynamic',
		{
			origin = Vector(x, y, 128),
			angles = rotationAngle
		}) 
	dyna:SetModel(model)
end

function create_room(x) 
end


