local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local funkyStuff = {}
local runFuncs = false
local json = dofile('mods'..getModDir()..'scripts/JSONLIB.lua')
function onEvent(n, o, t)
    if n == 'Stage Change' then
        local additionalModDirectory = getPropertyFromClass('Paths', 'currentModDirectory')
        if additionalModDirectory ~= '' or additionalModDirectory ~= nil then additionalModDirectory = additionalModDirectory..'/' else additionalModDirectory = '' end
        luaDebugMode = true
        
        local stageChangeFormat = [[

return {
    create = onCreate or nil,
    update = onUpate or nil,
    beathit = onBeatHit or nil,
    stephit = onStepHit or nil,
    startcountdown = onStartCountdown or nil,
    songstart = onSongStart or nil,
    onevent = onEvent or nil,
    goodnotehit = goodNoteHit or nil,
    opponentnotehit = opponentNoteHit or nil,
    createpost = onCreatePost or nil,
    updatepost = onUpdatePost or nil,
    deed = __OBSD or nil,
    deedee = destroyAll or nil
}

        ]]
        local curStg = getPropertyFromClass('PlayState', 'curStage')
        local curStgData = dofile('mods/'..additionalModDirectory..'stages/'..curStg..'.lua')
        if curStgData ~= nil and curStgData.newObjects ~= nil then
            for _, __ in pairs(curStgData.newObjects) do
                if __.isText then
                    removeLuaText(_)
                else
                    removeLuaSprite(_)
                end
                curStgData.Events = {}
                callOnLuas('stageDestroyed', {curStg}, false, false)
                callOnLuas('stageDiscardEvents', {curStg}, false, false)
            end
        else
            local stageChangeFormat2  = getTextFromFile('custom_events/__StageChangeFormat.lua')
            local piss = [[
local function destroyAll(stage)
    for _, __ in pairs(removeableObjects) do
        onUpdate = nil
        onUpdatePost = nil
        onBeatHit = nil
        onStepHit = nil
        
        removeLuaSprite(__)
        removeLuaSprite(_)
    end
end
            ]]
            saveFile('stages/'..curStg..'__TEMP.lua', stageChangeFormat2..'\n\n'..getTextFromFile('stages/'..curStg..'.lua')..'\n\n'..piss..'\n\n'..stageChangeFormat)
            local cassie = dofile('mods/stages/'..curStg..'__TEMP.lua')
            if cassie.create ~= nil then cassie.create() end
            if cassie.songstart ~= nil then cassie.songstart() end
            if cassie.createpost ~= nil then cassie.createpost() end
            if cassie.startcountdown ~= nil then cassie.startcountdown() end
            cassie.deedee()
            callOnLuas('stageDestroyed', {curStg}, false, false)
            deleteFile('stages/'..curStg..'__TEMP.lua')
        end
        local newStage = dofile('mods/stages/'..o..'.lua')
        if newStage ~= nil and newStage.newObjects ~= nil then
            for _, __ in pairs(newStage.charData) do
                scaleObject(_, 1, 1)
                setProperty(_..'.x', __.x)
                setProperty(_..'.y', __.y)
                for q_, _i in pairs(__.extraProperties) do
                    setProperty(_..'.'..q_, _i)
                end
                setObjectOrder(_, __.order)
                setBlendMode(_, __.blendmode)
            end
            runHaxeCode(
                'game.opponentCameraOffset[0] = '..(newStage.charData.dad.camPos.x)-(getMidpointX('dad')+150)..';\n'..
                'game.opponentCameraOffset[1] = '..(newStage.charData.dad.camPos.y)-(getMidpointY('dad')-100)..';\n'..

                'game.boyfriendCameraOffset[0] = '..(newStage.charData.boyfriend.camPos.x)-(getMidpointX('boyfriend')-100)..';\n'..
                'game.boyfriendCameraOffset[1] = '..(newStage.charData.boyfriend.camPos.y)-(getMidpointY('boyfriend')-100)..';\n'..

                'game.girlfriendCameraOffset[0] = '..newStage.charData.gf.camPos.x..';\n'..
                'game.girlfriendCameraOffset[1] = '..newStage.charData.gf.camPos.y..';\n'.. 
                'game.moveCamera('..tostring(not mustHitSection)..');\n'
            )
            for _, __ in pairs(newStage.newObjects) do
                if not __.isText then
                  if __.isAnimated then
                    makeAnimatedLuaSprite(_, __.path, __.x, __.y)
                  else
                    makeLuaSprite(_, __.path, __.x, __.y)
                    if __.isGraphic then makeGraphic(_, __.width, __.height, __.hex) end
                  end
                  addLuaSprite(_)
                else
                  makeLuaText(_, __.text, 0, __.x, __.y)
                  setTextColor(_, __.hex)
                  setTextSize(_, __.size)
                  setTextFont(_, __.font ~= nil and __.font or 'vcr.ttf')
                  addLuaText(_)
                end
                setObjectCamera(_, __.camera)
                setObjectOrder(_, __.order)
                for pr, op in pairs(__.extraProperties) do
                  setProperty(_..'.'..pr, op)
                end
                setBlendMode(_, __.blendmode)
            end
            function runStageEvents()
                for _, __ in pairs(newStage.Events) do
                    if __.func ~= nil then __.func() end
                end
            end
        else
            saveFile('stages/'..o..'__TEMP.lua', getTextFromFile('stages/'..o..'.lua')..'\n\n'..stageChangeFormat)
            
            local newStageData = dofile('mods/stages/'..o..'__TEMP.lua')
            local dir = json.parse(getTextFromFile('stages/'..o..'.json'))
            setPropertyFromClass('Paths', 'currentModDirectory', dir.directory)

            setProperty('boyfriend.x', dir.boyfriend[1]) setProperty('boyfriend.y', dir.boyfriend[2])
            setProperty('dad.x', dir.opponent[1]) setProperty('dad.y', dir.opponent[2])
            setProperty('gf.x', dir.girlfriend[1]) setProperty('gf.y', dir.girlfriend[2])

            runHaxeCode(
                'game.opponentCameraOffset[0] = '..dir.camera_opponent[1]..';\n'..
                'game.opponentCameraOffset[1] = '..dir.camera_opponent[2]..';\n'..

                'game.boyfriendCameraOffset[0] = '..dir.camera_boyfriend[1]..';\n'..
                'game.boyfriendCameraOffset[1] = '..dir.camera_boyfriend[2]..';\n'..

                'game.girlfriendCameraOffset[0] = '..dir.camera_girlfriend[1]..';\n'..
                'game.girlfriendCameraOffset[1] = '..dir.camera_girlfriend[2]..';\n'.. 
                'game.moveCamera('..tostring(not mustHitSection)..');\n'
            )

            if newStageData.create ~= nil then newStageData.create() end if newStageData.createpost ~= nil then newStageData.createpost() end
            onBeatHit = newStageData.beathit or onBeatHit
            onStepHit = newStageData.stephit or onStepHit
            goodNoteHit = newStageData.goodnotehit or goodNoteHit
            opponentNoteHit = newStageData.opponentnotehit or opponentNoteHit
            onUpdatePost = newStageData.updatepost or onUpdatePost
            runFuncs = true
            deleteFile('stages/'..o..'__TEMP.lua')
        end
        makeLuaSprite('flashy__', '', 0, 0)
        makeGraphic('flashy__', screenWidth, screenHeight, 'ffffff')
        setScrollFactor('flashy__', 0, 0)
        addLuaSprite('flashy__')

        doTweenAlpha('flashy__TWN', 'flashy__', 0, 0.4, 'smoothStepInOut')
        setPropertyFromClass('PlayState', 'curStage', o)

        if funkyStuff.onevent ~= nil then  funkyStuff.onevent(n, o, t) end
    end
end

function onUpdate(elapsed)
    if runStageEvents ~= nil then
        runStageEvents()
    end
    if runFuncs then
        funkyStuff.update(elapsed)
    end
    -- debugPrint(getPropertyFromClass('PlayState', 'curStage'))
end

-- highly recommend to use my own format to change between stages
-- since there are some regular lua stages that dont work with this when changed to them
-- but im sure that stage removal for regular ones is fine
-- also you can load regular stages in my stage editor so have fun i guess