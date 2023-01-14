local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local ToolBox = dofile('mods'..getModDir()..'scripts/Stage-Editor/ToolBox-Sublime.lua')
local dataBase = dofile('mods'..getModDir()..'scripts/dataBase.lua')
local Btncolor = (ToolBox['Variables'].preferences.darkMode and 'a2fffd' or 'ffffff')
local leColour = ToolBox['Variables'].preferences.darkMode and '31284a' or 'f63e70'
local song = (ToolBox['Variables'].preferences.darkMode and 'Street Night' or 'Street Day MIX')

function onStartCountdown()
    return Function_Stop;
end

function onCreate()
    playSound(song, 0, 'streetMusic')
    soundFadeIn('streetMusic', 1, 0, 0.6)
    ToolBox.Functions.loopSound('streetMusic', song, true, 1, 0, 0.6)
    setSoundTime('streetMusic', dataBase.getData('stageEditor', 'songTime'))

    setPropertyFromClass("flixel.FlxG", "mouse.visible", true)
    luaDebugMode = true
    ToolBox.Functions.Make_Quick.Sprite('background', '', 0, 0, 'camGame', true, true, false , 3000, 3000, leColour)
    ToolBox.Functions.Make_Quick.Sprite('Holder', 'stageEditor-Assets/makeEvent/'..(ToolBox.Variables.preferences.darkMode and 'dark' or 'light')..'/Holder', 0, 38, 'camGame', true)
    ToolBox.Functions['TextInput'].Make('functionCodeInput', 66.6799999999999, 66.38, 'Function Code', 430, 20, nil, Btncolor, 'stageEditor-Assets/makeText/'..(ToolBox.Variables.preferences.darkMode and '' or 'light')..'/textHolder', 10, -270,  0.72, 0.88, 'left')
    ToolBox.Functions['TextInput'].Make('variableInput', 518, 255, 'Variable', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox.Variables.preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.61, 0.55)
    ToolBox.Functions['TextInput'].Make('valueInput', 587, 392, 'Value', 100, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox.Variables.preferences.darkMode and 'dark' or 'light')..'/Small-Button_Prespective', 0, -10,  1, 1)
    ToolBox.Functions.Button.Make('Confirm', 1074, 567, 'Confirm', nil, Btncolor, 20, 
    {
        [1] = {func = 'reconvertToNonString', args = {'---@:variableInput.text', '---@:valueInput.text', '---@:functionCodeInput.text'}}
    },
    0, -7, 'stageEditor-Assets/buttons/'..(ToolBox.Variables.preferences.darkMode and 'dark' or 'light')..'/Small-Button_Prespective', 1, 1, 'game.camOther')
    setScrollFactor('background', 0, 0)
    setScrollFactor('Holder', 0, 0)

    runHaxeCode('functionCodeInput.lines = (functionCodeInput___BG.height/functionCodeInput.size)-1;')
end

function onUpdate()
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') then
        dataBase.saveData('stageEditor', 'songTime', getSoundTime('streetMusic'))
        soundFadeIn('streetMusic', 1, 0)
        loadSong('mainEditor')
    end
end

function reconvertToNonString(variable, amount, functionCode)
    amount = (type(amount) == "string" and '"'..amount..'"' or tostring(amount))
    functionCode = string.gsub(functionCode, '"', '\'')
    runHaxeCode('PlayState.instance.callOnLuas("callTableFunc", ["makeEvent", "nil", "nil", "nil", "'..variable..'", '..amount..', "'..functionCode..'"]);')
end