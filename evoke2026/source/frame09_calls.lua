--F09_st = 0

F09_conveyorState = nil
F09_conveyorSequencer = nil

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

function SeqItem_SetConveyorStateAtBeat(beat, xSpeed, led)
	return {
		trigger = beat and TriggerOnSceneBeat(beat) or nil,
		tick = function(seqItem, somaticState, seqTiming)
			F09_conveyorState.xSpeed = xSpeed
			F09_conveyorState.led = led
		end
	}
end

F09_conveyorSequenceDef = {
	SeqItem_SetConveyorStateAtBeat(nil, -0.05, "ok"),
	-- SeqItem_SetConveyorStateAtBeat(100, 0, "question"),
	-- SeqItem_SetConveyorStateAtBeat(110, 0, "ok"),
}

function Frame09_init()
	--F09_st = time()
	F09_conveyorSequencer = CreateSequencer(F09_conveyorSequenceDef)

	F09_conveyorState = {
		x = 0,
		xSpeed = -0.05, -- doesn't matter; to be overwritten by animation sequence.
		led = "ok",
	}
end

function Frame09(_, demoBeat, somaticState, sceneTiming)
	local t = sceneTiming.demoMillis-- (tt - F09_st)
	AddHudMessage(string.format("sceneBeat: %.2f", sceneTiming.demoBeats))

	vbank(0)

	cls()
	drawSprite("F9_BG", 0, 0)

	-- animate the conveyor.
	UpdateSequencer(F09_conveyorSequencer, somaticState, sceneTiming)
	F09_conveyorState.x = F09_conveyorState.x + somaticState.demoDeltaMillis * F09_conveyorState.xSpeed
	--local sx = -t / 20
	AddHudMessage(string.format("conveyor.x: %d", F09_conveyorState.x // 1))
	F09_conveyor(F09_conveyorState.x)

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
