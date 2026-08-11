
scene_frame = 0
current_scene_id = 17

show_hud = false

function BOOT()
	-- load same palette on both banks
	vbank(0)
	tomem(unpac(pal))
	vbank(1)
	tomem(unpac(pal))
	vbank(0)

	-- load sprites
	loadFrame01Sprites() -- logo + ship docking
	loadFrame02Sprites() -- planet with ship in orbit
	loadFrame03Sprites() -- ship landing in slabs
	loadFrame04Sprites() -- ships taking off to space
	loadFrame05Sprites() -- leaving hub ship in curves
	loadFrame06Sprites() -- leaving hub ship in straights
	loadFrame07Sprites() -- leaving moving hub ship
	loadFrame08Sprites() -- modules
	loadFrame09Sprites() -- xray
	loadFrame11Sprites() -- ship next to particle vortex
	loadC01Sprites() -- triangle welding
	loadC02Sprites() -- ships departing
	loadTunnelSprites() -- ships for side tunnel scene

	-- init scenes
	scenes[current_scene_id].init()
	somatic_seek(scenes[current_scene_id].start*16)

	somatic_set_completion_callback(function ()
		trace(" - SPACE LOGISTICS - ")
		exit()
	end)
end

scenes = {
	{ -- missing "Space" on logo
		init = no_fn,
		frame = Frame01,
		bdr = no_fn,
		start = 0,
		row = 0,
	},{
		init = Frame02_init,
		frame = Frame02,
		bdr = no_fn,
		start = 4,
		row = 0,
	},{ -- missing credits on left maybe?
		init = no_fn,
		frame = Frame03,
		bdr = no_fn,
		start = 6,
		row = 0,
	},{
		init = Frame05_notraces,
		frame = Frame05,
		bdr = no_fn,
		start = 8,
		row = 0,
	},{
		init = Frame05_notraces,
		frame = Frame05b,
		bdr = no_fn,
		start = 9,
		row = 0,
	},{ -- maybe needs a hud surrounding of some sort?
		init = supernova_init,
		frame = supernova,
		bdr = no_fn,
		start = 10,
		row = 0,
	},{
		init = Frame05_init,
		frame = Frame05,
		bdr = no_fn,
		start = 11,
		row = 0,
	},{
		init = Frame05_init,
		frame = Frame05b,
		bdr = no_fn,
		start = 12,
		row = 0,
	},{ -- not synced to music, does it matter?
		init = Frame06_init,
		frame = Frame06,
		bdr = no_fn,
		start = 13,
		row = 0,
	},{ -- needs sharper turns on bezier, better thruster anim and syncs
		init = Frame07_init,
		frame = Frame07,
		bdr = no_fn,
		start = 14,
		row = 0,
	},{ -- right place for this?
		init = no_fn,
		frame = Frame04,
		bdr = no_fn,
		start = 15,
		row = 0,
	},{
		init = Frame08_init,
		frame = Frame08,
		bdr = no_fn,
		start = 17,
		row = 0,
	},{ -- maybe tune up background colors?!
		init = tunnel_init,
		frame = tunnel,
		bdr = no_fn,
		start = 19,
		row = 0,
	},{
		init = Frame09_init,
		frame = Frame09,
		bdr = no_fn,
		start = 21,
		row = 0,
	},{ -- sync to music, right order of sequence?
		init = Construction01_init,
		frame = Construction01,
		bdr = no_fn,
		start = 25,
		row = 0,
	},{ 
		init = Frame11_init,
		frame = Frame11,
		bdr = no_fn,
		start = 27,
		row = 0,
	},{ -- ships departing
		init = Construction02_init,
		frame = Construction02,
		bdr = no_fn,
		start = 29,
		row = 0,
	}
}

_beats = 0

function RenderHud(state)
	rect(0, 0, 240, 8, 0)

	-- convert millis to 00:00.000
	local millis = state.demoMillis
	local minutes = millis // 60000
	local seconds = (millis % 60000) // 1000
	local milliseconds = (millis % 1000) // 1
	local time_str = string.format("%02d:%02d.%03d", minutes, seconds, milliseconds)

	local blinkParity = time() // 500 % 2

	print(
		string.format(
			"%s scene:%d frame:%d beat:%.1f p%d r%d %s",
			time_str,
			current_scene_id,
			scene_frame,
			state.demoBeats,
			state.demoPatternIndex,
			state.demoPatternRow,
			state.isPlaying and "" or (blinkParity == 0 and "PAUSED" or "")
		),
		0,
		0,
		12, -- color
		true, -- fixed width
		1, -- scale
		true -- small font
	)
end


function TIC()
	local state = somatic_tick()
	if keyp(55) or btnp(3) then
		if current_scene_id < #scenes then
			current_scene_id = current_scene_id + 1
			scene_frame = 0
			scenes[current_scene_id].init()
			--somatic_init(scenes[current_scene_id].start, 0)
			state = somatic_seek(scenes[current_scene_id].start*16)
		end
	end
	if keyp(54) or btnp(2) then
		if current_scene_id > 1 then
			current_scene_id = current_scene_id - 1
			scene_frame = 0
			scenes[current_scene_id].init()
			--somatic_init(scenes[current_scene_id].start, 0)
			state = somatic_seek(scenes[current_scene_id].start*16)
		end
	end
	if keyp(13) then -- M
		state = somatic_set_options({ isMuted = not state.isMuted })
	end
	if keyp(48) then -- SPACE
		state = somatic_set_options({ isPlaying = not state.isPlaying })
	end
	if keyp(16) then -- P
		show_hud = not show_hud
	end

	--local track, playingSongOrder, currentFrame, currentRow = somatic_get_state()
	local track = state.demoPatternIndex
	local playingSongOrder = state.demoPatternIndex
	local currentRow = state.demoPatternRow

	if state.isPlaying then
		-- music is playing, update last known position
		lastKnownOrder = playingSongOrder
		lastKnownRow = currentRow
	end

	--hide cursor
	--poke(16379, 2)

	-- get global music sync refs
	local _pO = state.demoPatternIndex--playingSongOrder
	local _row = state.demoPatternRow--peek(0x13FFE)

	if
		current_scene_id < #scenes
		and _pO >= scenes[current_scene_id + 1].start
		and _row ~= 255
		and _row >= scenes[current_scene_id + 1].row
	then
		current_scene_id = current_scene_id + 1
		scene_frame = 0
		scenes[current_scene_id].init()
	end
	scenes[current_scene_id].frame(time(), state.demoBeats)

	if show_hud then
		RenderHud(state)
	end

	scene_frame = scene_frame + 1

	somatic_end_frame()

	--print(current_scene_id .. " " .. _pO .. " " .. _row, 0, 130,12)
end

function BDR(l)
	scenes[current_scene_id].bdr(l)
end
