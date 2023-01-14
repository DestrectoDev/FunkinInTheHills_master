function onCreate()

    makeLuaSprite('healthSide2', '', screenWidth-20, screenHeight-(screenHeight*50)/100)
    makeGraphic('healthSide2', 20, (screenHeight*50)/100, getHealthBarColor('boyfriend'))
    setObjectCamera('healthSide2', 'other')
    addLuaSprite('healthSide2', true)

    makeLuaSprite('healthSide1', '', 0, screenHeight-(screenHeight*50)/100)
    makeGraphic('healthSide1', 20, (screenHeight*50)/100, getHealthBarColor('dad'))
    setObjectCamera('healthSide1', 'other')
    addLuaSprite('healthSide1', true)

    makeLuaText("timer", 'TIME: M:SS', 0, 20, screenHeight-100)
    setObjectCamera("timer", "other")
    addLuaText("timer", true)
    setTextSize("timer", 50)
    setTextFont("timer", "YANDERE.TTF")

    makeLuaText("scorething", 'SCORE: N/A', 0, 15, getProperty("timer.y")-getProperty("timer.height")-10)
    setObjectCamera("scorething", "other")
    addLuaText("scorething", true)
    setTextSize("scorething", 50)
    setTextFont("scorething", "YANDERE.TTF")

    makeLuaText("missthing", 'MISSES: 0', 0, 10, getProperty("scorething.y")-getProperty("scorething.height")-10)
    setObjectCamera("missthing", "other")
    addLuaText("missthing", true)
    setTextSize("missthing", 50)
    setTextFont("missthing", "YANDERE.TTF")

    makeLuaText("bestCombo", 'BEST COMBO: 0', 0, 10, getProperty("missthing.y")-getProperty("missthing.height")-10)
    setObjectCamera("bestCombo", "other")
    addLuaText("bestCombo", true)
    setTextSize("bestCombo", 50)
    setTextFont("bestCombo", "YANDERE.TTF")

    setProperty("timer.angle", -3)
    setProperty("missthing.angle", -3)
    setProperty("scorething.angle", -3)
    setProperty("bestCombo.angle", -3)

    setTextColor('timer', 'ff7881')
    setTextColor('scorething', 'ff7881')
    setTextColor('missthing', 'ff3d7b')
    setTextColor('bestCombo', 'ff3d7b')

    setTextBorder('timer', 2, 'ffffff')
    setTextBorder('scorething', 2, 'ffffff')

    setProperty('healthBarBG.visible', false)
    setProperty('healthBar.visible', false)
    setProperty('timeTxt.visible', false)
    setProperty('timeBar.visible', false)
    setProperty('timeBarBG.visible', false)
    setProperty('scoreTxt.visible', false)
    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)

--     makeLuaSprite('iconPlayer1', '', 0, screenHeight/2-50)
--     setObjectCamera('iconPlayer1', 'other')
--     addLuaSprite('iconPlayer1', true)
--     makeLuaSprite('iconPlayer2', '', screenWidth-20, screenHeight/2-50)
--     setObjectCamera('iconPlayer2', 'other')
--     addLuaSprite('iconPlayer2', true)
end

local o = false
local scoreBlah = 0
local bestcombo = 0
local healthThing = 1
local healthn = 1

function lerp(a, b, ratio)
    return a + ratio * (b - a)
end
function boundTo(value, min, max)
    return math.max(min, math.min(max, value));
end
local posi
local timex

function onSongStart() o = true end
function onUpdatePost(elapsed)
    luaDebugMode = true
    healthThing = lerp(healthThing, math.max(0, 2-getProperty('health')), boundTo(elapsed * 30, 0, 1))
    healthn = lerp(healthn, getProperty('health'), boundTo(elapsed * 30, 0, 1))
    if o then
        bestcombo = math.max(bestcombo, getProperty('combo'))
        scoreBlah = math.floor(lerp(scoreBlah, getProperty('songScore'), boundTo(elapsed * 30, 0, 1)))
        if getPropertyFromClass('Conductor', 'songPosition') > 141000  then
            posi = lerp(posi, (getPropertyFromClass('Conductor', 'songPosition')-( timeBarType == 'Time Elapsed' and 120000 or 0))/1000, elapsed*2)
        else
            posi = timeBarType == 'Time Elapsed' and getPropertyFromClass('Conductor', 'songPosition')/1000 or (getPropertyFromClass('Conductor', 'songPosition')+120000)/1000 
        end
        if timeBarType == 'Time Elapsed' then
            timex = posi
        else
            timex = (songLength-(posi*1000))/1000
        end
        setTextString('timer', 'TIME: '..(formatTime(math.floor(timex))), 0, 2)
        setTextString('scorething', 'SCORE: '..scoreBlah)
        setTextString('missthing', 'MISSES: '..getProperty('songMisses'))
        setTextString('bestCombo', 'BEST COMBO: '..bestcombo)
    end
    setGraphicSize('healthSide2', 20, (screenHeight*(healthn*100))/200)
    setGraphicSize('healthSide1', 20, (screenHeight*(healthThing*100))/200)

    setProperty('healthSide2.y', screenHeight-(screenHeight*(healthn*100))/200)
    setProperty('healthSide1.y', screenHeight-(screenHeight*(healthThing*100))/200)

    -- setProperty('iconPlayer1.x', getProperty('healthSide1.x')+getProperty('healthSide1.width')/2)
    -- setProperty('iconPlayer2.x', getProperty('healthSide2.x')-getProperty('healthSide2.width')/2-getProperty('iconPlayer2.width'))

    -- setProperty('iconPlayer1.scale.x', getProperty('iconP2.scale.x'))
    -- setProperty('iconPlayer2.scale.x', getProperty('iconP1.scale.x'))
    
    -- setProperty('iconPlayer1.scale.y', getProperty('iconP2.scale.y'))
    -- setProperty('iconPlayer2.scale.y', getProperty('iconP1.scale.y'))

    -- setProperty('iconPlayer2.flipX', true)

    -- runHaxeCode(
    --     'game.getLuaObject("iconPlayer1").frames = game.iconP2.frames;\n'..
    --     'game.getLuaObject("iconPlayer2").frames = game.iconP1.frames;\n'..

    --     'game.getLuaObject("iconPlayer1").frame = game.iconP2.frame;\n'..
    --     'game.getLuaObject("iconPlayer2").frame = game.iconP1.frame;\n'
    -- )

    -- luaDebugMode = true

    if math.floor(healthn) == 2 then
        setProperty('healthSide2.alpha', lerp(getProperty('healthSide2.alpha'), 0, elapsed*2))
    else
        setProperty('healthSide2.alpha', lerp(getProperty('healthSide2.alpha'), 1, elapsed*2))
    end
end

function formatTime(seconds)
    seconds = math.floor(seconds)
    local minutes = math.floor(seconds / 60)
    local secondsString = tostring(seconds%60)
    if #secondsString < 2 then secondsString = '0'..secondsString end
    return string.format('%d:%s', minutes, secondsString)
end

function formatFakeTime(realSeconds, seconds_Fake_Mult, minutes_FakeMult)
    return formatTime(realSeconds-(seconds_Fake_Mult+(minutes_FakeMult*60)))
end

function to_hex(r, g, b) return string.format('%x', (r * 0x10000) + (g * 0x100) + b) end
function getHealthBarColor(char)
    return to_hex(getProperty(char..'.healthColorArray[0]'), getProperty(char..'.healthColorArray[1]'), getProperty(char..'.healthColorArray[2]'))
end