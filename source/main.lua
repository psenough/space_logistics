--#include "import:song:CODE" -- include somatic music playroutine

--#include "source/frame01_sprites.lua"
--#include "source/frame02_sprites.lua"
--#include "source/frame03_sprites.lua"
--#include "source/frame04_sprites.lua"
--#include "source/frame05_sprites.lua"
--#include "source/frame06_sprites.lua"
--#include "source/frame09_sprites.lua"
--#include "source/frame07_sprites.lua"
--#include "source/frame08_sprites.lua"
--#include "source/frame11_sprites.lua"
--#include "source/tunnel_sprites.lua"
--#include "source/construction01_sprites.lua"
--#include "source/construction02_sprites.lua"
--#include "source/construction03_sprites.lua"
--#include "source/spherescenes_sprites.lua"
--#include "source/tunnel2_sprites.lua"
--#include "source/endscene_sprites.lua"
--#include "source/hud_sprites.lua"

--#include "source/bootstrap.lua"

--#include "source/twinkles.lua"
--#include "source/particle_orbits.lua"

--#include "source/frame01_calls.lua"
--#include "source/frame02_calls.lua"
--#include "source/frame03_calls.lua"
--#include "source/frame04_calls.lua"
--#include "source/frame05_calls.lua"
--#include "source/frame06_calls.lua"
--#include "source/frame07_calls.lua"
--#include "source/frame08_calls.lua"
--#include "source/frame09_calls.lua"
--#include "source/frame11_calls.lua"
--#include "source/tunnel.lua"
--#include "source/construction01_calls.lua"
--#include "source/construction02_calls.lua"
--#include "source/construction03_calls.lua"
--#include "source/spherescenes_calls.lua"
--#include "source/tunnel2_calls.lua"
--#include "source/endscene_calls.lua"
--#include "source/hud_calls.lua"

scene_frame = 0
current_scene_id = 1
show_hud = false
show_palette = false
last_somatic_state = nil
hmr_request = nil -- for HMR, tells TIC() to init.
mouse_origin = nil -- set explicit origin with 'o' for measuring distances
hud_messages = {}

scenes = {
	{ -- missing "Space" on logo
		init = no_fn,
		frame = Frame01, -- ship docking
		name = "Frame01",
		bdr = no_fn,
		start = 0,
		row = 0,
		rowHandler = TwinkleRowHandler,
	},{
		init = Frame02_init,
		frame = Frame02, -- planets with ships in orbit
		name = "Frame02",
		bdr = no_fn,
		start = 4,
		row = 0,
		rowHandler = TwinkleRowHandler,
	},{ -- missing credits on left maybe?
		init = no_fn,
		frame = Frame03, -- cargo ship flying over slabs
		name = "Frame03",
		bdr = no_fn,
		start = 6,
		row = 0,
		rowHandler = TwinkleRowHandler,
	},{
		init = Frame05_notraces,
		frame = Frame05, -- stationary orbit 5a
		name = "Frame05",
		bdr = no_fn,
		start = 8,
		row = 0,
		rowHandler = TwinkleRowHandler,
	},{
		init = Frame05b_notraces,
		frame = Frame05b, -- stationary orbit 5b
		name = "Frame05b",
		bdr = no_fn,
		start = 9,
		row = 0,
	},{ -- maybe needs a hud surrounding of some sort?
		init = HUD_01_init,
		frame = HUD_01_Scene,
		name = "HUD_01_Scene",
		bdr = no_fn,
		start = 10,
		row = 0,
	},{
		init = Frame05_init,
		frame = Frame05, -- 5a ships leaving
		name = "Frame05",
		bdr = no_fn,
		start = 11,
		row = 0,
	},{
		init = Frame05b_init,
		frame = Frame05b, -- 5b ships leaving
		name = "Frame05b",
		bdr = no_fn,
		start = 12,
		row = 0,
	},{ -- not synced to music, does it matter?
		init = Frame06_init,
		frame = Frame06, -- dune ships leaving
		name = "Frame06",
		bdr = no_fn,
		start = 13,
		row = 0,
	},{ -- needs sharper turns on bezier, better thruster anim and syncs
		init = Frame07_init,
		frame = Frame07, -- big ship, ships leaving
		name = "Frame07",
		bdr = no_fn,
		start = 14,
		row = 0,
	},{
		init = Frame04_init,
		frame = Frame04, -- take off
		name = "Frame04",
		bdr = no_fn,
		start = 15,
		row = 0,
	},{
		init = Frame08_init,
		frame = Frame08, -- modules undocking
		name = "Frame08",
		bdr = no_fn,
		start = 16,
		row = 32,
	},{
		init = tunnel_init,
		frame = tunnel,
		name = "tunnel",
		bdr = no_fn,
		start = 19,
		row = 0,
	},{ -- hud red alert
		init = HUD_01_init,
		frame = HUD_01_Scene,
		name = "HUD_01_Scene",
		bdr = no_fn,
		start = 21,
		row = 0,
	},{
		init = Frame11_init,
		frame = Frame11, -- plasma orbit
		name = "Frame11",
		bdr = no_fn,
		start = 23,
		row = 0,
	},{
		init = Construction03_init,
		frame = Construction03, -- industrial planet elements
		name = "Construction03",
		bdr = no_fn,
		start = 25,
		row = 0,
	},{ -- sync to music, right order of sequence?
		init = Construction01_init,
		frame = Construction01, -- welding
		name = "Construction01",
		bdr = no_fn,
		start = 28,
		row = 0,
	},{
		init = Tunnel2_init,
		frame = Tunnel2,
		name = "Tunnel2",
		bdr = no_fn,
		start = 29,
		row = 0,
	},{
		init = Construction02_init,
		frame = Construction02, -- ships departing big dock with parts
		name = "Construction02",
		bdr = no_fn,
		start = 31,
		row = 0,
	},{
		init = SphereScenes_init,
		frame = SphereScenes,
		name = "SphereScenes",
		bdr = no_fn,
		start = 33,
		row = 0,
	},{
		init = EndScene_init,
		frame = EndScene,
		name = "EndScene",
		bdr = no_fn,
		start = 36,
		row = 0,
	},{
		init = Frame09_init,
		frame = Frame09, -- xray luggage
		name = "Frame09",
		bdr = no_fn,
		start = 39,
		row = 0,
	}
}

function SetScene(scene_id, do_seek)
	if scene_id >= 1 and scene_id <= #scenes then
		current_scene_id = scene_id
		scene_frame = 0
		TwinkleNewScene(current_scene_id)
		scenes[current_scene_id].init()
		if do_seek then
			somatic_seek(scenes[current_scene_id].start*16)
		end
	end
end

function handleSomaticRow(state)
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

	-- load sprites
	loadFrame01Sprites() -- logo + ship docking
	loadFrame02Sprites() -- planet with ship in orbit
	loadFrame03Sprites() -- ship landing in slabs
	loadFrame04Sprites() -- ships taking off to space
	loadFrame05Sprites() -- leaving hub ship in curves
	loadFrame06Sprites() -- leaving hub ship in straights
	loadFrame07Sprites() -- leaving moving hub ship
	loadFrame08Sprites() -- modules
	loadFrame09Sprites() -- xray scanning
	loadFrame11Sprites() -- ship next to particle vortex
	loadC01Sprites() -- triangle welding
	loadC02Sprites() -- ships departing
	loadC03Sprites() -- ship flying over factory elements
	loadTunnelSprites() -- ships for side tunnel scene
	loadSSSprites() -- sphere scenes
	loadTunnel2Sprites() -- tunnel 2
	loadEndSceneSprites() -- end scene
	loadHUDSprites() -- HUD

	somatic_set_completion_callback(function ()
		trace(" - SPACE LOGISTICS - ")
		exit()
	end)

	somatic_set_row_callback(handleSomaticRow)

	-- init scenes
	SetScene(current_scene_id, true)
end

--#ifdef DEBUG
-- ticbuild allows HMR for tic80 carts. before the old cart is killed, the tic80 calls the
-- returned function to get a state snapshot to pass to the next cart.
function MakeHMRState()
	if last_somatic_state == nil then
		return nil
	end
	-- return current state
	return {
		yep_its_me = true,
		scene_id = current_scene_id,
		show_hud = show_hud,
		is_playing = last_somatic_state.isPlaying,
		is_muted = last_somatic_state.isMuted,
		mouse_origin_x = mouse_origin and mouse_origin.x or nil,
		mouse_origin_y = mouse_origin and mouse_origin.y or nil,
		show_palette = show_palette,
	}
end
function HMR(state)
	if state and state.yep_its_me
	and type(state.scene_id) == "number"
	and type(state.show_hud) == "boolean"
	and type(state.is_playing) == "boolean" and type(state.is_muted) == "boolean"
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

function TIC()
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
	scenes[current_scene_id].frame(time(), state.demoBeats, state)

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

function BDR(l)
	scenes[current_scene_id].bdr(l)
end
