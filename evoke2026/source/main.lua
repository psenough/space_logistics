--#include "import:song:CODE" -- include somatic music playroutine

--#include "source/sprite.lua"
--#include "source/frame09_sprites.lua"
--#include "source/hud_sprites.lua"
--#include "source/title_evoke_sprites.lua"
--#include "source/evoke_hud_sprites.lua"

--#include "source/bootstrap.lua"

--#include "source/sequencer.lua"
--#include "source/sideChannelQuery.lua"

--#include "source/twinkles.lua"
--#include "source/particle_orbits.lua"

--#include "source/frame09_calls.lua"
--#include "source/title_evoke_calls.lua"
--#include "source/evoke_hud_calls.lua"

scene_frame = 0
-- the scene orchestrator tracks scene-based timing, so scenes have a stable timing
-- reference.
scene_timing_start = nil
scene_timing = {
	demoMillis = 0,
	demoBeats = 0,
	wallMillis = 0,
}
current_scene_id = 1
show_hud = false
show_palette = false
last_somatic_state = nil
hmr_request = nil -- for HMR, tells TIC() to init.
mouse_origin = nil -- set explicit origin with 'o' for measuring distances
hud_messages = {}
is_booting = true
boot_start_time = time()

scenes = {
	{
		init = function() TEvoke_init("intro") end,
		frame = TEvoke,
		name = "TEvoke",
		bdr = no_fn,
		start = 0,
		row = 0,
	},
	{
		init = Frame09_init,
		frame = Frame09, -- xray luggage
		name = "Frame09",
		bdr = no_fn,
		start = 2,
		row = 0,
	},
	{-- FACES
		init = Evoke_HUD_init,
		frame = Evoke_HUD, -- evoke HUD
		name = "Evoke HUD",
		bdr = no_fn,
		start = 9,
		row = 0,
	},
	-- {-- (just so i can seek easily)
	-- 	init = Evoke_HUD_init,
	-- 	frame = Evoke_HUD, -- evoke HUD
	-- 	name = "Evoke HUD",
	-- 	bdr = no_fn,
	-- 	start = 10,
	-- 	row = 0,
	-- },
	{ -- 11
		init = function() TEvoke_init("melody") end,
		frame = TEvoke,
		name = "TEvoke",
		bdr = no_fn,
		start = 11,
		row = 0
	},
	{-- FACES
		init = Evoke_HUD_init,
		frame = Evoke_HUD, -- evoke HUD
		name = "Evoke HUD",
		bdr = no_fn,
		start = 12,
		row = 0,
	},
	{ -- B section: title again ** NOT SURE ABOUT THIS ONE.... **
		init = function() TEvoke_init("melody") end,
		frame = TEvoke,
		name = "TEvoke",
		bdr = no_fn,
		start = 13,
		row = 0
	},

	{-- SOLO
		init = Evoke_HUD_init,
		frame = Evoke_HUD, -- evoke HUD
		name = "Evoke HUD",
		bdr = no_fn,
		start = 15,
		row = 0,
	},
	{-- B section melody: baggage variation
		init = Frame09_init,
		frame = Frame09, -- xray luggage
		name = "Frame09",
		bdr = no_fn,
		start = 20,
		row = 0,
	},
	-- end card
	{
		init = function() TEvoke_init("end") end,
		frame = TEvoke,
		name = "TEvoke",
		bdr = no_fn,
		start = 22,
		row = 0
	},
}

function ResetSceneTiming()
	scene_timing_start = nil
	scene_timing.demoMillis = 0
	scene_timing.demoBeats = 0
	scene_timing.wallMillis = 0
end

function UpdateSceneTiming(somaticState)
	if scene_timing_start == nil then
		scene_timing_start = {
			demoMillis = somaticState.demoMillis,
			demoBeats = somaticState.demoBeats,
			wallMillis = somaticState.wallMillis,
		}
	end

	scene_timing.demoMillis = somaticState.demoMillis - scene_timing_start.demoMillis
	scene_timing.demoBeats = somaticState.demoBeats - scene_timing_start.demoBeats
	scene_timing.wallMillis = somaticState.wallMillis - scene_timing_start.wallMillis
end

function SetScene(scene_id, do_seek)
	if scene_id >= 1 and scene_id <= #scenes then
		current_scene_id = scene_id
		scene_frame = 0
		ResetSceneTiming()
		local scene = scenes[current_scene_id]
		BeginSideChannelScope(scene.start, scene.row)
		TwinkleNewScene(current_scene_id)
		scene.init()
		if do_seek then
			somatic_seek_position(scene.start, scene.row)
		end
	end
end

function handleSomaticRow(state)
	SideChannelDatabase_SomaticRowHandler(state)
	local sceneRowHandler = scenes[current_scene_id].rowHandler
	if sceneRowHandler then
		sceneRowHandler(state)
	end
end

function BOOT()
	-- load same palette on both banks
	vbank(0)
	tomem(unpac(pal))
	vbank(1)
	tomem(unpac(pal))
	vbank(0)
	InitSideChannelDatabase()

	somatic_set_completion_callback(function()
		trace(" - CALL 1-800-FLIGHT TO REBOOK - ")
		exit()
	end)

	somatic_set_row_callback(handleSomaticRow)
end

--#ifdef DEBUG
-- ticbuild allows HMR for tic80 carts. before the old cart is killed, the tic80 calls the
-- returned function to get a state snapshot to pass to the next cart.
function MakeHMRState()
	if last_somatic_state == nil then
		return nil
	end
	-- return current state
	local currentScene = scenes[current_scene_id]
	local sceneState = nil
	if currentScene and currentScene.hmr_get then
		sceneState = currentScene.hmr_get()
	end
	return {
		yep_its_me = true,
		scene_id = current_scene_id,
		show_hud = show_hud,
		is_playing = last_somatic_state.isPlaying,
		is_muted = last_somatic_state.isMuted,
		mouse_origin_x = mouse_origin and mouse_origin.x or nil,
		mouse_origin_y = mouse_origin and mouse_origin.y or nil,
		show_palette = show_palette,
		scene_state = sceneState,
	}
end
function HMR(state)
	if
		state
		and state.yep_its_me
		-- accept previous run's state.
		and type(state.scene_id) == "number"
		and type(state.show_hud) == "boolean"
		and type(state.is_playing) == "boolean"
		and type(state.is_muted) == "boolean"
	then
		if state.show_hud ~= nil then
			show_hud = state.show_hud
		end
		if state.mouse_origin_x ~= nil and state.mouse_origin_y ~= nil then
			mouse_origin = { x = state.mouse_origin_x, y = state.mouse_origin_y }
		end
		if state.show_palette ~= nil then
			show_palette = state.show_palette
		end
		hmr_request = {
			current_scene_id = state.scene_id,
			is_playing = state.is_playing,
			is_muted = state.is_muted,
			scene_state = state.scene_state,
		}
	end
	return MakeHMRState -- return callback
end

function HonorHMRState()
	if hmr_request then
		somatic_set_options({
			isPlaying = hmr_request.is_playing,
			isMuted = hmr_request.is_muted,
		})
		SetScene(hmr_request.current_scene_id, true)
		if hmr_request.scene_state then
			local currentScene = scenes[current_scene_id]
			if currentScene and currentScene.hmr_set then
				currentScene.hmr_set(hmr_request.scene_state)
			end
		end
		hmr_request = nil
	end
end
--#endif -- DEBUG

--#ifdef DEBUG
function AddHudMessage(msg)
	table.insert(hud_messages, msg)
end

function RenderHud(state)
	rect(0, 0, 240, 8, 0)

	-- convert millis to 00:00.000
	local millis = state.demoMillis
	local minutes = millis // 60000
	local seconds = (millis % 60000) // 1000
	local milliseconds = (millis % 1000) // 1
	local time_str = string.format("%02d:%02d.%03d", minutes, seconds, milliseconds)

	local blinkParity = time() // 500 % 2
	local current_scene = scenes[current_scene_id] or {}

	print(
		string.format(
			"%s scn:%d frm:%d beat:%.1f p%d r%d %s %s",
			time_str,
			current_scene_id,
			scene_frame,
			state.demoBeats,
			state.demoPatternIndex,
			state.demoPatternRow,
			current_scene.name or "",
			state.isPlaying and "" or (blinkParity == 0 and "PAUSED" or "")
		),
		0,
		0,
		12, -- color
		true, -- fixed width
		1, -- scale
		true -- small font
	)
	-- show mouse cursor coords
	local mx, my = mouse()
	if mouse_origin then
		local dx = mx - mouse_origin.x
		local dy = my - mouse_origin.y
		print(string.format("(%d,%d) DXY=(%d,%d)", mx, my, dx, dy), 0, 6, 12)
		line(mouse_origin.x, mouse_origin.y, mx, my, 12)
	else
		print(string.format("(%d,%d)", mx, my), 0, 6, 12)
	end

	-- render hud messages line by line.
	for i, msg in ipairs(hud_messages) do
		print(msg, 0, 6 + i * 6, 12)
	end

	--print(string.format("(%d,%d)", mx, my), 0, 6, 12)
end

function RenderPalette()
	local swatchSize = 240 // 16
	for i = 0, 15 do
		rect(i * swatchSize, 136 - swatchSize, swatchSize, swatchSize, i)
		print(i, i * swatchSize + 2, 136 - swatchSize + 2, 0)
	end
end
--#endif -- DEBUG

function DemoTIC()
	hud_messages = {}
	local state = somatic_tick()

	--#ifdef DEBUG
	HonorHMRState()
	--#endif

	if keyp(55) or btnp(3) then
		SetScene(current_scene_id + 1, true)
	end
	if keyp(54) or btnp(2) then
		SetScene(current_scene_id - 1, true)
	end
	--#ifdef DEBUG
	if keyp(56) then -- HOME
		SetScene(1, true)
	end
	if keyp(57) then -- END
		SetScene(#scenes, true)
	end
	if keyp(54) then -- PGUP
		SetScene(current_scene_id - 5, true)
	end
	if keyp(55) then -- PGDN
		SetScene(current_scene_id + 5, true)
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
	if keyp(12) then -- L https://skyelynwaddell.github.io/tic80-manual-cheatsheet/#_buttons
		show_palette = not show_palette
	end
	if keyp(15) then -- O
		if mouse_origin == nil then
			local mx, my = mouse()
			mouse_origin = { x = mx, y = my }
		else
			mouse_origin = nil
		end
	end
	--#endif -- DEBUG

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
	--#ifdef DEBUG
	poke(16379, show_hud and 128 or 2) -- show cursor when hud is on
	--#else
	poke(16379, 2) -- hide cursor always in release
	--#endif

	-- get global music sync refs
	local _pO = state.demoPatternIndex --playingSongOrder
	local _row = state.demoPatternRow --peek(0x13FFE)

	if
		current_scene_id < #scenes
		and _pO >= scenes[current_scene_id + 1].start
		and _row >= scenes[current_scene_id + 1].row
	then
		current_scene_id = current_scene_id + 1
		scene_frame = 0
		ResetSceneTiming()
		local scene = scenes[current_scene_id]
		BeginSideChannelScope(scene.start, scene.row)
		scene.init()
	end
	UpdateSceneTiming(state)
	scenes[current_scene_id].frame(time(), state.demoBeats, state, scene_timing)

	--#ifdef DEBUG
	if show_hud then
		RenderHud(state)
	end
	if show_palette then
		RenderPalette()
	end
	--#endif

	scene_frame = scene_frame + 1

	last_somatic_state = state
	somatic_end_frame()

	--print(current_scene_id .. " " .. _pO .. " " .. _row, 0, 130,12)
end

current_boot_task_index = 1
BootTasks = {
	-- load sprites
	loadFrame09Sprites,
	loadHUDSprites,
	loadTEvokeSprites,
	loadEvokeHUDSprites
}

function TIC()
	if is_booting then
		-- do 1 boot task per frame (it will stall still but at least we can show stepped progress)
		if current_boot_task_index <= #BootTasks then
			BootTasks[current_boot_task_index]()
			current_boot_task_index = current_boot_task_index + 1

			-- draw a progress bar.
			cls(0)
			local progress01 = current_boot_task_index / #BootTasks
			local barWidth = 199
			local barHeight = 13
			local barX = (TIC_WIDTH() - barWidth) // 2
			local barY = (TIC_HEIGHT() - barHeight) // 2
			rect(barX, barY, barWidth, barHeight, 8)
			rect(barX, barY, barWidth * progress01, barHeight, 9)
		else
			is_booting = false
			-- init scene
			--trace(string.format("BOOT %.2f seconds", (time() - boot_start_time) / 1000))
			SetScene(current_scene_id, true)
		end
	else
		DemoTIC()
	end
end

function BDR(l)
	if not is_booting then
		scenes[current_scene_id].bdr(l)
	end
end
