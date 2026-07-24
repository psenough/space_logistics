
function BOOT()
	tomem(unpac(pal))
    loadFrame01Sprites()
	loadFrame02Sprites()
	loadFrame03Sprites()
end

scenes = {
	{
		init = no_fn,
		frame = Frame01,
		bdr = no_fn,
		start = 0,
		row = 0,
	},{
		init = no_fn,
		frame = Frame02,
		bdr = no_fn,
		start = 2,
		row = 0,
	},{
		init = no_fn,
		frame = Frame03,
		bdr = no_fn,
		start = 3,
		row = 0,
	}
}

scene_frame = 0
current_scene_id = 3

scenes[current_scene_id].init()
somatic_init(scenes[current_scene_id].start, 0)

function TIC()
	if keyp(55) then
		if current_scene_id < #scenes then
			current_scene_id = current_scene_id + 1
			scene_frame = 0
			scenes[current_scene_id].init()
			somatic_init(scenes[current_scene_id].start, 0)
		end
	end
	if keyp(54) then
		if current_scene_id > 1 then
			current_scene_id = current_scene_id - 1
			scene_frame = 0
			scenes[current_scene_id].init()
			somatic_init(scenes[current_scene_id].start, 0)
		end
	end

	somatic_tick()
	local track, playingSongOrder, currentFrame, currentRow = somatic_get_state()

	if track ~= -1 then -- if playing
		lastKnownOrder = playingSongOrder
		lastKnownRow = currentRow
	else
		trace(" - SPACE LOGISTICS - ")
		exit()
	end

	if btnp(2) then -- left
		somatic_init(math.max(0, playingSongOrder - 1), 0)
	end
	if btnp(3) then -- right
		-- clamping...
		local nextPattern = math.min(somatic_get_song_order_count() - 1, playingSongOrder + 1)
		somatic_init(nextPattern, 0)
	end
	if btnp(1) then -- down
		if track == -1 then
			somatic_init(lastKnownOrder, lastKnownRow)
		else
			somatic_stop()
		end
	end

	--hide cursor
	poke(16379, 2)

	-- get global music sync refs
	local _pO = playingSongOrder
	local _row = peek(0x13FFE)

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
	scenes[current_scene_id].frame(time())

	scene_frame = scene_frame + 1

--	print(current_scene_id .. " " .. _pO .. " " .. _row, 0, 130)
end

function BDR(l)
	scenes[current_scene_id].bdr(l)
end
