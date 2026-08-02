# notes on importing the music

📖[Somatic instructions for using in demo](https://github.com/thenfour/Somatic#how-to-export--how-to-use-in-a-demo)

## tldr

- use the **Lua code** from the music cart (obviously minus the TIC() fn)
- import some chunks from the music cart:
  - `MUSIC_PATTERNS`
  - `MUSIC_TRACKS`
  - `WAVEFORMS`
  - `SFX`

Refer to the music cart for how to use in your demo. Minimal required usage is like:

```lua
function TIC()
	local state = somatic_tick()
	somatic_end_frame()
end
```

Here's the full Somatic music cart entry point just for reference (same as in the music cart):

```lua
function TIC()
	local state = somatic_tick()

	if btnp(2) then -- left
		state = somatic_seek(math.max(0, state.demoBeats - 1))
	end
	if btnp(3) then -- right
		state = somatic_seek(state.demoBeats + 1)
	end
	if btnp(1) then -- down
		state = somatic_set_options({ isPlaying = not state.isPlaying })
	end
	if keyp(13) then -- M
		state = somatic_set_options({ isMuted = not state.isMuted })
	end
	if btnp(0) then -- up
		state = somatic_advance_frame()
	end

	cls(0)
	local y = 2
	print("Somatic playroutine", 0, y, 12)
	y = y + 8
	print("Left/Right = prev/next beat", 0, y, 15)
	y = y + 8
	print("Down = pause/resume", 0, y, 15)
	y = y + 8
	print("Up = step paused transport", 0, y, 15)
	y = y + 8
	print("M = mute toggle", 0, y, 15)
	y = y + 8
	print(
		string.format(
			"play:%s mute:%s beat:%.2f pat:%d row:%d",
			state.isPlaying and "y" or "n",
			state.isMuted and "y" or "n",
			state.demoBeats,
			state.demoPatternIndex,
			state.demoPatternRow
		),
		0,
		y,
		6
	)
	somatic_end_frame()
end
```
