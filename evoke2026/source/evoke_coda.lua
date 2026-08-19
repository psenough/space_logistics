function EvokeCodaInit()
    vbank(0)
    cls(0)
    vbank(1)
    cls(0)
    vbank(0)
end

function EvokeCodaTick(_, _, somaticState, sceneTiming)
    cls(0)
	drawSprite("TEvoke_bg",0,0)

    local event = QuerySideChannelPart(somaticState, "endAccent")

    drawSprite("SPRITE_TICKETBG", 0, 9)
    drawSprite("SPRITE_LOGO", 3, 15)
    drawSprite("SPRITE_TEXTFIELD", 4, 67)

    if sceneTiming.demoBeats > 2 then
        drawSprite("SPRITE_DESTINATION", 6, 70)
    end
    if sceneTiming.demoBeats > 4 then
        drawSprite("SPRITE_BOARDINGTIME", 6, 88)
    end

    AddHudMessage(string.format("eventcount = %d", event.count))

    local cha = QuerySideChannelPart(somaticState, "cha")
    if cha.count == 1 or cha.count == 3 then
        drawSprite("SPRITE_CANCELED", 33, 12)
        if cha.count == 3 and cha.justHit then
            for i = 1, 10 do
                AddTwinkle()
            end
        end
    end

    TwinkleTick(somaticState, "starz")
end

