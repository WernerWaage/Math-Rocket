function love.load()
	-- Oh hi hilsen werner
	-- Cools hilsen Svein Even
	
	-- Load images:
	cloud = love.graphics.newImage("gfx/Clouds.png")
	bgImage = love.graphics.newImage("gfx/bg.png")
	particle = love.graphics.newImage("gfx/simpleparticle.png")
	asteroid = love.graphics.newImage("gfx/asteroid.png")
	
	
	-- Declare constants
	sFactor = 1.0	
	meHeight = love.graphics.getHeight
	meWidth = love.graphics.getWidth
	speed = 100
	systems = {} -- Table
	questionsMultiplication = 
	{
		{ "What is 1X2",2 }, 
		{ "What is 2X2",4 }, 
		{ "What is 4X1",4 }, 	
		{ "What is 3X2",6 }, 	
		{ "What is 1X1",1 }, 	
		{ "What is 3X1",3 }, 		
		{ "What is 4X2",8 } 
	} -- Table

	
	-- Declare Variables
	bgYoffset = -1200
	scroller = 0
	Wind = 0		
	answervalue = 0
	correctanswer = 0
	fuel = 100
	velocity = 100
	altitudeBonus = 1

	question = ""  
	questionSolution = 0  

	bgMaxBounds = -1
	rocket = love.graphics.newImage("gfx/rocket_1.png")
	rocketId = 1
	rocketXpos = 350
	
	-- Score:
	gAltitude = 0
	
	-- Set Fonts:
	font = love.graphics.newImageFont("gfx/Imagefont.png"," abcdefghijklmnopqrstuvwxyz" .."ABCDEFGHIJKLMNOPQRSTUVWXYZ0" .."123456789.,!?-+/():;%&`'*#=[]\"")

	-- Game Settings:
	gGameStarted = 0
	
	-- The amazing music.
	music = love.audio.newSource("sound/prondisk.xm")
	love.audio.play(music, 9)
 
	
	-- Test Variables:
	direction = 0
	num = 0
	current = 1
	
	-- Simple Particle Declaration (insert p into systems table)
	local p = love.graphics.newParticleSystem(particle, 1000)
	p:setEmissionRate(20)
	p:setSpeed(300, 400)
	p:setGravity(100)
	p:setSizes(2, 1)
	p:setColors(255, 255, 255, 255, 58, 128, 255, 0)
	p:setPosition(400, 300)
	p:setLifetime(1)
	p:setParticleLife(1)
	p:setDirection(180)
	p:setSpread(180)
	p:setRadialAcceleration(-2000)
	p:setTangentialAcceleration(1000)
	p:stop()
	table.insert(systems, p)
	
		-- Asteroids:
	local p = love.graphics.newParticleSystem(asteroid, 1000)
	p:setEmissionRate(6)
	p:setSpeed(100, 250)
	p:setGravity(10, 80)
	p:setSizes(0.1, 1.3)
	p:setColors(238, 233, 233, 155, 255, 250, 250, 255)
	p:setPosition(400, 300)
	p:setLifetime(1)
	p:setParticleLife(20)
	p:setDirection(130)
	p:setSpread(70)
	p:setSpin(1, 5)
	p:stop()
	table.insert(systems, p)
	
	-- Rektangel (draggable), test med sprite
	rect = {
	rectx = 50,
	recty = 50,
	rectwidth = 50,
	rectheight = 50,
	dragging = { active = false, diffX = 0, diffY = 0 }
	}

 
	
end

function love.draw()
	drawBottom()
	drawCloud()
	drawMyRocket()
	drawInfoText()
	
	-- Print FPS in top left corner:
	love.graphics.print("FPS: "..love.timer.getFPS(), 10, 30)

	-- create draggable box:
	love.graphics.rectangle("fill", rect.rectx, rect.recty, rect.rectwidth, rect.rectheight)
	

	if correctanswer == 1 then
		CorrectAnswer()
		-- Wait a few seconds..	
		CreateQuestion()
		answervalue = 0
		correctanswer = 0
	elseif correctanswer == 2 then
		love.graphics.print("Nope try again ... " , 222, 333)
	end

end
function drawInfoText()
	love.graphics.setFont(font)
	scoreBackground = love.graphics.setColor(255,255,0,200) -- Red font
	scoreBackground = love.graphics.print("Altitude: "..round(gAltitude,1) , 10, 10, 0, 1.0, 1.0)
	
	scoreBackground = love.graphics.setColor(255,0,0) -- Red font
	if gGameStarted == 0 then
		scoreForeground = love.graphics.print("Press S to Start" , 180, 60, 0, sx, sx)	
		scoreForeground = love.graphics.print("Press R to change rocket" , 180, 80, 0, sx, sx)
		love.graphics.print("System: [" .. current .. "/"..table.getn(systems).."] - " .. systems[current]:count() .. " particles.", 180, 100);
		scoreForeground = love.graphics.print("Solve the mathematical problems by adding numbers 1-5 together" , 180, 120, 0, sx, sx)
		scoreForeground = love.graphics.print("Press space to test your answer, or backspace to start over" , 180, 140, 0, sx, sx)
		scoreBackground = love.graphics.setColor(255,255,100) -- Red font	
		scoreForeground = love.graphics.print(" Game by Yell0w 2012 " , 280, 180, 0, sx, sx)
	end



	love.graphics.print(question , 180, 270)
	if answervalue ~= 0 then	
		love.graphics.print("Answer: " .. answervalue , 180, 300)
	end

	-- Reset colours:
	scoreForeground = love.graphics.setColor(255,255,255)
end

function drawBottom()
	love.graphics.draw(bgImage, 0, bgYoffset)
end

function drawMyRocket()
	love.graphics.draw(rocket, rocketXpos, 550)
	-- Add Smoke:
	love.graphics.setColorMode("modulate")
	--love.graphics.setBlendMode("additive") WTF?!?
	love.graphics.draw(systems[1], 0, 0)
	systems[1]:setPosition(rocketXpos+50, 550+200)
	systems[1]:start()

	love.graphics.draw(systems[2], 0, 0)
	systems[2]:setPosition(400,-600)
	systems[2]:start()
 
end

function drawCloud()
	mycloud = love.graphics.setColor(255,255,255, 100)
	mycloud = love.graphics.draw(cloud, 570+Wind, scroller+80, 0,0.2)	
	mycloud = love.graphics.draw(cloud, 40+Wind, scroller+120, 0,0.15)	
	love.graphics.setColor(255,255,255,255)
end

function CreateQuestion()
	if question == "" then
		-- Select random row from the table:
		tablerows = table.maxn(questionsMultiplication)
  		randomrow = math.random(1,tablerows )
		question = questionsMultiplication[randomrow][1]
		questionSolution = questionsMultiplication[randomrow][2]
	end

end

function CorrectAnswer()
	gAltitude = gAltitude + 100
	question = ""
end


function love.update(dt)
	-- Scroll bg or stop:
	if gGameStarted == 1 then
			
		scroller = scroller + (13 * dt) -- start scrolling slower (other stuffses)
		if bgYoffset < bgMaxBounds then
			 bgYoffset  = bgYoffset  + (speed * dt)
		-- else
			
		end
	end
	Wind = Wind + (3 * dt)


  
   -- Update Score:
   if gGameStarted == 1 then
   gAltitude = gAltitude + (dt*altitudeBonus)
   end

  if love.keyboard.isDown("right") then
      rocketXpos = rocketXpos  + (speed * dt)
   elseif love.keyboard.isDown("left") then
      rocketXpos  = rocketXpos  - (speed * dt)
   end
	if rocketXpos < 0 or rocketXpos > 710 then
		rocketXpos = 350
	end
	
	-- Call forth sprites of doom!:
	systems[1]:update(dt)
	if gGameStarted == 1 then
		systems[2]:update(dt)
	end

  if rect.dragging.active then
    rect.rectx = love.mouse.getX() - rect.dragging.diffX
    rect.recty = love.mouse.getY() - rect.dragging.diffY
  end

end


function love.mousepressed(rectx, recty, button)
  if button == "l"
  and rectx > rect.rectx and rectx < rect.rectx + rect.rectwidth
  and recty > rect.recty and recty < rect.recty + rect.rectheight
  then
    rect.dragging.active = true
    rect.dragging.diffX = rectx - rect.rectx
    rect.dragging.diffY = recty - rect.recty
  end
end

function love.mousereleased(x, y, button)
  if button == "l" then rect.dragging.active = false end
end

function love.focus(f)
  if not f then
    print("LOST FOCUS")
  else
    print("GAINED FOCUS")
  end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end

function love.keypressed(key)
   	if key == "s" then
	      gGameStarted = 1
		CreateQuestion()
	end

	if key == "return" or key == " " then
		if questionSolution == answervalue then
			correctanswer = 1
		else
			correctanswer = 2
		end
	end
	if key == "escape" then
		love.event.push("q")
	end
	if key == "1" then
		answervalue = answervalue+1
	end
	if key == "2" then
		answervalue = answervalue+2
	end
	if key == "3" then
		answervalue = answervalue+3
	end
	if key == "4" then
		answervalue = answervalue+4
	end	
	if key == "5" then
		answervalue = answervalue+5
	end	

	if key == "backspace" or key == "delete" then
		answervalue = 0
	end

	

	if key == "r" then
	rollthis = math.random(1,2)
		if  rollthis == 2 then
			 rocket = love.graphics.newImage("gfx/rocket_2.png")
		else
			 rocket = love.graphics.newImage("gfx/rocket_1.png")
		end
	end

	if key == "rctrl" then
		debug.debug()
	end
end

-- Hjelpefunksjoner
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
