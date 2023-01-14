local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local ToolBox = dofile('mods'..getModDir()..'scripts/Stage-Editor/ToolBox-Sublime.lua')
local mode = (ToolBox['Variables'].preferences.darkMode)
local dataBase = dofile('mods'..getModDir()..'scripts/dataBase.lua')
local Btncolor = (mode and 'a2fffd' or 'ffffff')
local leColour = mode and '31284a' or 'ff3a46'
local song = (mode and 'Street Night' or 'Street Day MIX')

local curSelected = 1
local c = false
local displayPage = false

function onStartCountdown()
    return Function_Stop;
end
function onCreate()
    luaDebugMode = true
    playSound(song, 0, 'streetMusic')
    soundFadeIn('streetMusic', 1, 0, 0.6)
    setSoundTime('streetMusic', dataBase.getData('stageEditor', 'songTime'))
    ToolBox.Functions.loopSound('streetMusic', song, true, 1, 0, 0.6)

    runHaxeCode('loopedAnim = false;')

    setPropertyFromClass("ClientPrefs", "hideHud", true)
    setPropertyFromClass("flixel.FlxG", "mouse.visible", true)

    ToolBox.Functions.Make_Quick.Sprite('background', '', 0, 0, 'camGame', true, true, false , 3000, 3000, leColour)
    ToolBox.Functions.Make_Quick.Sprite('buttonHolder', 'stageEditor-Assets/makeAnimation/'..(mode and 'dark' or 'light')..'/BigHolder', 108, 26, 'camGame', true)
    ToolBox.Functions.Make_Quick.Sprite('animDataHolder', 'stageEditor-Assets/makeAnimation/'..(mode and 'dark' or 'light')..'/animDataHolder', 760, 26, 'camGame', true)

    ToolBox.Functions.Make_Quick.Text('animData', 'NONE', 0, 0, ToolBox.Variables.preferences.font, Btncolor, 20, 'camOther', true)
    setTextBorder('animData', 2, leColour)
    setTextAlignment('animData', 'Center')

    setScrollFactor('background', 0, 0)
    setScrollFactor('buttonHolder', 0, 0)
    setScrollFactor('animDataHolder', 0, 0)

    ToolBox.Functions['TextInput'].Make('objectTagInput', 279, 38, 'Sprite', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.7, 0.6)
    ToolBox.Functions['TextInput'].Make('animationTagInput', 116, 182, 'Animation', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.7, 0.6)
    ToolBox.Functions['TextInput'].Make('animationPrefixInput', 425, 182, 'Prefix', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.7, 0.6)
    ToolBox.Functions['TextInput'].Make('FPSinput', 460, 358, 'FPS', 120, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Small-Button', 0, -5, 0.481, 0.458)

    ToolBox.Functions.Button.Make('switchPage', 1101, 1, '>', nil, Btncolor, 27, 
    {
        [1] = {func = 'switchS', args = {''}}
    },
    0, -7, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Small-Button', 0.33, 0.3, 'game.camOther')
    
    ToolBox.Functions.Button.Make('switchPage2', screenWidth-70, screenHeight/2, '<', nil, Btncolor, 27, 
    {
        [1] = {func = 'switchY', args = {''}}
    },
    0, -7, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Small-Button', 0.2, 0.2, 'game.camOther')
 
    ToolBox.Functions.Button.Make('toggleLoop', 130, 365, 'Looped: FALSE', nil, Btncolor, 27, 
    {
        [1] = {func = 'callHaxe', cont = 'loopedAnim = !loopedAnim;'}
    },
    0, -7, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0.7, 0.6, 'game.camOther')
    c = true
    ToolBox.Functions.Button.Make('Confirm', 365, 560, 'Confirm', nil, Btncolor, 25, 
    {
        [1] = {func = 'callTableFunc', args = {'MakeAnimation', 'nil', 'nil', 'nil', '---@:objectTagInput.text', '---@:animationTagInput.text', '---@:animationPrefixInput.text', '---@:FPSinput.text', '---@:loopedAnim'}}
    },
    0, -7, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Small-Button_Prespective', 1, 1, 'game.camOther')
    
    ToolBox.Functions.Make_Quick.Sprite('spriteHolder', 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Sprite-Displayer', screenWidth*2, 47, 'camOther', true, false, false)
    setScrollFactor('spriteHolder', 0, 0)
    makeAnimatedLuaSprite('display__0__')
    setObjectCamera('display__0__', "other")
    addLuaSprite('display__0__', true)
    setScrollFactor('display__0__', 0, 0)
end

local _Object = 'NOT FOUND'
local _txt = 'NONE'
local anims = {}

function dquickie(str) _Object = str end
function table.contains(tbl, k) for _, __ in pairs(tbl) do if __ == k then return true end end end
function onUpdate()
    if c then
        runHaxeCode([[
            if (loopedAnim)
                toggleLoop.label.text = "Looped: TRUE";
            else
                toggleLoop.label.text = "Looped: FALSE";
            PlayState.instance.callOnLuas("dquickie", [objectTagInput.text]);
        ]])
    end

    if ToolBox.Data.newObjects[_Object] == nil then
        _Object = 'NOT FOUND'
    end

    if _Object ~= 'NOT FOUND' then
        if ToolBox.Data.newObjects[_Object].isAnimated then
            if ToolBox.Data.newObjects[_Object].animations ~= nil then
                quickBool = true
                for _, __ in pairs(ToolBox.Data.newObjects[_Object].animations) do
                    if not table.contains(anims, _) then
                        table.insert(anims, _)
                    end
                end
                if ToolBox.Data.newObjects[_Object].animations[anims[curSelected]] ~= nil then
                    _txt = anims[curSelected]..'\n'..
                    'Prefix: '..ToolBox.Data.newObjects[_Object].animations[anims[curSelected]].Prefix..'\n'..
                    'Looped: '..tostring(ToolBox.Data.newObjects[_Object].animations[anims[curSelected]].Looped)..'\n'..
                    'FPS: '..ToolBox.Data.newObjects[_Object].animations[anims[curSelected]].FPS..'\n'

                    setTextString('animData', _txt)
                else
                    _txt = 'NONE'
                end
                setProperty('display__0__.visible', true)
                runHaxeCode('PlayState.instance.callOnLuas("displayToHolderB", [objectTagInput.text, "displayAnim", animationPrefixInput.text, FPSinput.text]);')
            end
        else
            setProperty('display__0__.visible', false)
            curSelected = 1
        end
    else
        setProperty('display__0__.visible', false)
        curSelected = 1
        anims = {}
    end

    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') then
        dataBase.saveData('stageEditor', 'songTime', getSoundTime('streetMusic'))
        soundFadeOut('streetMusic', 1, 0)
        loadSong('mainEditor')
    end


    setProperty('animData.x', getProperty('animDataHolder.x')+getProperty('animDataHolder.width')/2-getProperty('animData.width')/2)
    setProperty('animData.y', getProperty('animDataHolder.y')+getProperty('animDataHolder.height')/2-getProperty('animData.height')/2+5)
end

function switchS()
    curSelected = curSelected + 1
    if curSelected > #anims then
        curSelected = 1
    end
end

function switchY()
    displayPage = not displayPage
    if displayPage then
        doTweenX('transformIn', 'spriteHolder', screenWidth/2-getProperty('spriteHolder.width')/2, 0.2, 'elasticOut')
    else
        doTweenX('transformOut', 'spriteHolder', screenWidth*2, 0.2, 'smoothStepInOut')
    end
    runHaxeCode(
        'objectTagInput.active = '..tostring(not displayPage)..';\n'..
        'animationTagInput.active = '..tostring(not displayPage)..';\n'..
        'animationPrefixInput.active = '..tostring(not displayPage)..';\n'..
        'FPSinput.active = '..tostring(not displayPage)..';\n'..
        'switchPage2.text = '..(displayPage and '">"' or '"<"')..';'
    )
end

local oldQ = {
    object = 'NONE',
    animTag = '',
    Prefix = '',
    fps = 24,
    looped = false
}
function displayToHolderB(obj, animTag, Prefix, fps)
    if oldQ.object ~= obj or oldQ.animTag ~= animTag or oldQ.Prefix ~= Prefix or oldQ.fps ~= fps  then
        removeLuaSprite(obj)
        makeAnimatedLuaSprite('display__0__')
        setObjectCamera('display__0__', "other")
        addLuaSprite('display__0__', true)
        setScrollFactor('display__0__', 0, 0)

        loadFrames('display__0__', ToolBox.Data.newObjects[obj].path)

        addAnimationByPrefix('display__0__', 'displayAnim', Prefix, fps, true)
        playAnim('display__0__', 'displayAnim', true)
        oldQ.object = obj
        oldQ.animTag = animTag
        oldQ.Prefix = Prefix
        oldQ.fps = fps
    end

    if getProperty('display__0__.width') > getProperty('spriteHolder.width') or getProperty('display__0__.height') > getProperty('spriteHolder.height') then
        fixScale('spriteHolder', 'display__0__', -100)
    else
        scaleObject('display__0__', 1, 1)
    end

    setProperty('display__0__.x', getProperty('spriteHolder.x')+getProperty('spriteHolder.width')/2-getProperty('display__0__.width')/2)
    setProperty('display__0__.y', getProperty('spriteHolder.y')+getProperty('spriteHolder.height')/2-getProperty('display__0__.height')/2)
end

function fixScale(sprite1, sprite2, mult)
    setGraphicSize(sprite2, getProperty(sprite1..'.width')+mult, getProperty(sprite1..'.height')+mult)
    updateHitbox(sprite2)
    local ratio =  math.min(getProperty(sprite2..'.scale.x'), getProperty(sprite2..'.scale.y'))
    scaleObject(sprite2, ratio, ratio)
end