--F09_st = 0

F09_conveyorState = nil
F09_conveyorSequencer = nil
F09_variation = nil

function F09_goodLed(t)
	local blinkPeriodMs = 700
	local blink = (t % blinkPeriodMs) / blinkPeriodMs
	local ledX = 155
	local ledY = 20
	if blink < 0.9 then
		--rect(ledX,ledY,9,9,5)
		rect(138, 22, 41, 7, 5)
	end
	-- draw a checkmark
	local okcolor = 15
	pix(ledX + 1, ledY + 4, 7)
	pix(ledX + 2, ledY + 5, 7)
	pix(ledX + 3, ledY + 6, 7)
	pix(ledX + 4, ledY + 5, 7)
	pix(ledX + 5, ledY + 4, 7)
	pix(ledX + 6, ledY + 3, 7)
	pix(ledX + 7, ledY + 2, 7)

	pix(ledX + 1, ledY + 4 + 1, 15)
	pix(ledX + 2, ledY + 5 + 1, 15)
	pix(ledX + 3, ledY + 6 + 1, 15)
	pix(ledX + 4, ledY + 5 + 1, 15)
	pix(ledX + 5, ledY + 4 + 1, 15)
	pix(ledX + 6, ledY + 3 + 1, 15)
	pix(ledX + 7, ledY + 2 + 1, 15)
end

function F09_questionLed(t)
	local blinkPeriodMs = 300
	local blink = (t % blinkPeriodMs) / blinkPeriodMs
	if blink < 0.5 then
		--rect(ledX,ledY,9,9,5)
		rect(138, 22, 41, 7, 4)
	end
	-- draw a checkmark
	local ledX = 150
	local ledY = 22
	print("???", ledX + 2, ledY + 2, 15)
	print("???", ledX + 2, ledY + 1, 3)
end

function F09_badLed(t)
	local blinkPeriodMs = 300
	local blink = (t % blinkPeriodMs) / blinkPeriodMs
	local ledX = 155
	local ledY = 20
	if blink < 0.5 then
		--rect(ledX,ledY,9,9,5)
		rect(138, 22, 41, 7, 2)
	end
	-- draw an exclamation.
	rect(ledX + 4, ledY + 1, 3, 6, 4)
	rect(ledX + 4, ledY + 8, 3, 2, 4)
end

function F09_conveyor(sx)
	local px = sx + 200
	-- sx = scanner x
	-- px = conveyor x

	drawSprite("F9_Suitcase_01", px, 52)
	print("TPOLM", px + 10, 76, 1, false, 1, true)

	px = px + 200
	drawSprite("F9_Suitcase_02", px, 52)
	print("POO-BRAIN", px + 66, 74, 8, false, 1, true)

	px = px + 200
	drawSprite("F9_Suitcase_01", px, 52)
	print("RBBS", px + 56, 96, 1, false, 1, true)

	px = px + 200
	drawSprite("F9_Alien_01", px, 40)

	px = px + 100
	drawSprite("F9_Suitcase_02", px, 52)
	print("Evoke 2026", px + 66, 74, 8, false, 1, true)

	px = px + 200
	drawSprite("F9_Duck_02", px, 56)

	px = px + 100
	drawSprite("F9_Suitcase_01", px, 52)
	print("TPOLM", px + 10, 76, 1, false, 1, true)

	px = px + 200
	drawSprite("F9_Suitcase_02", px, 52)
	print("POO-BRAIN", px + 66, 74, 8, false, 1, true)

	px = px + 200
	drawSprite("F9_Suitcase_01", px, 52)
	print("RBBS", px + 56, 96, 1, false, 1, true)

	px = px + 200
	drawSprite("F9_Suitcase_01", px, 52)

	px = px + 200
	drawSprite("F9_Suitcase_02", px, 52) -- and you

	vbank(1)
	--cls()
	drawSprite("F9_ScannerBG", 83, 34)

	sx = sx + 200
	drawSprite("F9_ESuitcase_02", sx, 52)

	sx = sx + 200
	drawSprite("F9_ESuitcase_03", sx, 52)

	sx = sx + 200
	drawSprite("F9_ESuitcase_01", sx, 52)

	sx = sx + 200
	drawSprite("F9_Alien_02", sx, 40)

	sx = sx + 100
	drawSprite("F9_ESuitcase_04", sx, 52)

	sx = sx + 200
	drawSprite("F9_Duck_01", sx, 56)

	sx = sx + 100
	drawSprite("F9_Suitcase_Scan_01", sx, 52)
	print("Spectrox", sx + 8, 76, 6, false, 1, true)
	print("Agenda", sx + 88, 76, 6, false, 1, true)
	print("Otomata Labs", sx + 28, 82, 6, false, 1, true)
	print("The Black Lotus", sx + 48, 88, 6, false, 1, true)
	print("Spectrals", sx + 68, 94, 6, false, 1, true)
	print("Accession", sx + 8, 94, 6, false, 1, true)
	print("Konsumer", sx + 28, 100, 6, false, 1, true)

	sx = sx + 200
	drawSprite("F9_Suitcase_Scan_02", sx, 52)
	print("The Twitch Elite", sx + 48, 70, 6, false, 1, true)
	print("Slipstream", sx + 28, 76, 6, false, 1, true)
	print("SIMurai", sx + 108, 76, 6, false, 1, true)
	print("Damage", sx + 48, 82, 6, false, 1, true)
	print("Forsaken", sx + 68, 88, 6, false, 1, true)
	print("Marquee Design", sx + 88, 94, 6, false, 1, true)
	print("Joker", sx + 28, 100, 6, false, 1, true)

	sx = sx + 200
	drawSprite("F9_Suitcase_Scan_01", sx, 52)
	print("Altair", sx + 8, 76, 6, false, 1, true)
	print("Abberation Creations", sx + 28, 82, 6, false, 1, true)
	print("Oftenhide", sx + 48, 88, 6, false, 1, true)
	print("Dreamweb", sx + 68, 94, 6, false, 1, true)
	print("Rift", sx + 8, 94, 6, false, 1, true)
	print("BionFX", sx + 88, 100, 6, false, 1, true)
	print("Elude", sx + 28, 100, 6, false, 1, true)

	sx = sx + 200
	drawSprite("F9_Suitcase_Scan_01", sx, 52)
	print("Rabenauge", sx + 8, 76, 6, false, 1, true)
	print("Abyss Connection", sx + 28, 82, 6, false, 1, true)
	print("Haujobb", sx + 48, 88, 6, false, 1, true)
	print("K2", sx + 88, 100, 6, false, 1, true)
	print("Akronyme Analogiker", sx + 8, 94, 6, false, 1, true)
	print("Stargaze", sx + 28, 100, 6, false, 1, true)

	sx = sx + 200
	drawSprite("F9_Suitcase_Scan_02", sx, 52)
	print("... and you!", sx + 48, 88, 6, false, 1, true)
end

F09_keyboardMiddleDef = {
	mainSpriteId = "SPRITE_KEYBOARD_MIDDLE",
	scannedSpriteId = "SPRITE_KEYBOARD_MIDDLE_OVERLAY",
	offsetY = 14,
	itemWidth = 42,
}

F09_soloConveyorDef = {
	{
		mainSpriteId = "SPRITE_BOWLINGBALL",
		scannedSpriteId = "SPRITE_BOWNLINGBALL_OVERLAY",
		offsetY = 25,
		itemWidth = 80,
	},
	{
		mainSpriteId = "SPRITE_BOMB",
		scannedSpriteId = "SPRITE_BOMB_OVERLAY",
		offsetY = 0,
		itemWidth = 200,
	},
	{
		mainSpriteId = "SPRITE_KEYBOARD_START",
		scannedSpriteId = "SPRITE_KEYBOARD_START_OVERLAY",
		offsetY = 14,
		itemWidth = 41,
	},
	F09_keyboardMiddleDef,
	F09_keyboardMiddleDef,
	F09_keyboardMiddleDef,
	F09_keyboardMiddleDef,
	F09_keyboardMiddleDef,
	F09_keyboardMiddleDef,
	F09_keyboardMiddleDef, 
	F09_keyboardMiddleDef,
	F09_keyboardMiddleDef,
	F09_keyboardMiddleDef, 
	F09_keyboardMiddleDef,
	F09_keyboardMiddleDef, 
	F09_keyboardMiddleDef,
	F09_keyboardMiddleDef,
	F09_keyboardMiddleDef,
	{
		mainSpriteId = "SPRITE_KEYBOARD_END",
		scannedSpriteId = "SPRITE_KEYBOARD_END_OVERLAY",
		offsetY = 14,
		itemWidth = 41,
	}
}

function ConveyorSolo(sx)
	sx = sx + 200
	local px = sx

	for i, item in ipairs(F09_soloConveyorDef) do
		drawSprite(item.mainSpriteId, px, 52 + item.offsetY)
		px = px + item.itemWidth
	end

	vbank(1)
	drawSprite("F9_ScannerBG", 83, 34)

	for i, item in ipairs(F09_soloConveyorDef) do
		drawSprite(item.scannedSpriteId, sx, 52 + item.offsetY)
		sx = sx + item.itemWidth
	end
end

F09_conveyorSequenceDef = {
	{
		tick = function(seqItem, somaticState, seqTiming, sceneTiming)
			local xSpeed = -0.05
			F09_conveyorState.x = sceneTiming.demoMillis * xSpeed
			F09_conveyorState.led = "ok"
		end
	},
}

-- during solos we will modulate the speed of the conveyor belt and set led states.
F09_soloSequenceDef = {
	{
		tick = function(seqItem, somaticState, seqTiming, sceneTiming)
			--local targetSpeed = -0.09

			-- modulate targetspeed.
			-- local convX = F09_conveyorState.x
			-- local led = "ok"
			-- if convX < 380 then
			-- 	targetSpeed = -0.09
			-- 	led = "question"
			-- end

			--local speed = UpdateSlewedScalar(F09_conveyorState.speed, targetSpeed, 0.001)
			local speed = -0.08
			F09_conveyorState.x = sceneTiming.demoMillis * speed
			F09_conveyorState.led = "ok"
			--F09_conveyorState.speed = speed
		end
	},
}

-- variation = "greetz" or "solo"
function Frame09_init(variation)
	F09_variation = variation
	local seqDef = F09_conveyorSequenceDef
	if variation == "solo" then
		seqDef = F09_soloSequenceDef
	end
	F09_conveyorSequencer = CreateSequencer(seqDef)

	F09_conveyorState = {
		-- gets set in sequencer tick.
		x = 0,
		speed = 0,
	}
end

function Frame09(_, demoBeat, somaticState, sceneTiming)
	local t = sceneTiming.demoMillis
	--AddHudMessage(string.format("sceneBeat: %.2f", sceneTiming.demoBeats))

	vbank(0)

	cls()
	drawSprite("F9_BG", 0, 0)

	-- animate the conveyor.
	UpdateSequencer(F09_conveyorSequencer, somaticState, sceneTiming)
	--AddHudMessage(string.format("conveyor.x: %d", F09_conveyorState.x // 1))
	if F09_variation == "greetz" then
		F09_conveyor(F09_conveyorState.x)
	else
		ConveyorSolo(F09_conveyorState.x)
	end
	-- clip around
	rect(0, 0, 240, 19, 0)
	rect(0, 19, 74, 117, 0)
	rect(184, 19, 56, 117, 0)

	drawSprite("F9_Frame", 0, 51)

	drawSprite("F9_Scannerframe", 73, 19)
	-- blinky light
	if F09_conveyorState.led == "ok" then
		F09_goodLed(t)
	elseif F09_conveyorState.led == "question" then
		F09_questionLed(t)
	else
		F09_badLed(t)
	end

	-- twinkles are too distracting from the luggage.

	-- local melodyEvent = QuerySideChannelPart(somaticState, "melody")
	-- local melodyBEvent = QuerySideChannelPart(somaticState, "melBrhythm")
	-- if melodyEvent.justHit or melodyBEvent.justHit then
	-- 	AddTwinkle()
	-- end
	-- TwinkleTick(somaticState, "starz")

end
