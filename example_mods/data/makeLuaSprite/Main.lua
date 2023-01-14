local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local ToolBox = dofile('mods'..getModDir()..'scripts/Stage-Editor/ToolBox-Sublime.lua')
local dataBase = dofile('mods'..getModDir()..'scripts/dataBase.lua')
local Btncolor = (ToolBox['Variables'].preferences.darkMode and 'a2fffd' or 'ffffff')
local leColour = ToolBox['Variables'].preferences.darkMode and '31284a' or 'ff3a46'
local song = (ToolBox['Variables'].preferences.darkMode and 'Street Night' or 'Street Day MIX')
local Tutorial = ToolBox.Variables.Tutorial
local Cheryl = dofile('mods'..getModDir()..'scripts/Stage-Editor/Cheryl.lua')

function onStartCountdown()
    if Tutorial and dataBase.getData('Cheryl', 'tutorialSteps') >= 7 and dataBase.getData('Cheryl', 'tutorialSteps') < 14 then
        Cheryl.Spawn(0, true)
        Cheryl.stepDialogue = {
            [8] = 'This is the sprites section.\nIn here, you can make normal and animated sprites\nthat will be displayed in the sprite displayer.\n>\n',
            [9] = 'To make a sprite, first, you have to name your sprite.\nDo that by clicking on the text field called "Sprite Tag"\nand replacing it with the name of your sprite.\n>\n',
            [10] = 'Put your image path in the text field called\n"Image Path".\n>\n',
            [11] = 'Select a camera by putting your camera name in the text field called\n"Camera".\n>\n',
            [12] = 'If you want your sprite to be animated,\nclick on the "Animated" button.\n>\n',
            [13] = 'Make the sprite by clicking the "Confirm" button.\n>\n',
            [14] = 'Click ESCAPE to return to the main editor.\n'
        }
        if dataBase.getData('User_Data', 'Language') == 'Spanish' then
            Cheryl.stepDialogue = {
                [8] = 'Esta es la sección de sprites.\nPuedes crear sprites normales, o animados\nque se mostrarán en el visualizador.\n>\n',
                [9] = 'Para crear un sprite, tienes que darle un nombre.\nHaz clic en el recuadro de Sprite Tag\ny escribe el nombre de tu sprite.\n>\n',
                [10] = 'Escribe la ruta de la imágen en\n"Image Path".\n>\n',
                [11] = 'Selecciona una cámara escribiendo el nombre en\n"Camera".\n>\n',
                [12] = 'Si quieres que tu sprite sea animado,\nhaz clic en "Animated".\n>\n',
                [13] = 'Crea el sprite presionando Confirm (confirmar).\n>\n',
                [14] = 'Presiona ESCAPE to return para regresar al editor normal.\n'
            }
        end
        Cheryl.switchStep(dataBase.getData('Cheryl', 'tutorialSteps')+1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end
    return Function_Stop;
end
function onCreate()
    playSound(song, 0, 'streetMusic')
    soundFadeIn('streetMusic', 1, 0, 0.6)
    setSoundTime('streetMusic', dataBase.getData('stageEditor', 'songTime'))
    ToolBox.Functions.loopSound('streetMusic', song, true, 1, 0, 0.6)

    setPropertyFromClass("ClientPrefs", "hideHud", true)
    setPropertyFromClass("flixel.FlxG", "mouse.visible", true)
    runHaxeCode('animSection = false;')

    makeLuaSprite('sttst:Cover', '')
    makeGraphic('sttst:Cover', 3000, 3000, leColour)
    setObjectCamera('sttst:Cover', 'camGame')
    addLuaSprite('sttst:Cover', true)

    ToolBox.Functions.Make_Quick.Sprite('sttst:spriteHolder', 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Sprite-Displayer', 23, 47, 'camGame', true, false, false)
    ToolBox.Functions.Make_Quick.Sprite('sttst:buttonHolder', 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Button-Holder', 931, 50, 'camGame', true, false, false)
    setScrollFactor('sttst:buttonHolder', 0, 0)
    setScrollFactor('sttst:spriteHolder', 0, 0)

    ToolBox.Functions['TextInput'].Make('test', 955, 61, 'Sprite Tag', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.635, 0.525)
    ToolBox.Functions['TextInput'].Make('test2', 955, 187, 'Image Path', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.635, 0.525)
    ToolBox.Functions['TextInput'].Make('test3', 955, 310, 'Camera', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.635, 0.525)
    ToolBox.Functions.Button.Make('test4', 955, 432, 'Confirm', nil, Btncolor, 22, 
        {
            [1] = {func = 'callTableFunc', args = {'MakeSprite', 'nil', 'nil', 'nil', '---@:test.text', '---@:test2.text', '---@:test3.text', '---@:animSection', false}}
            ,[2] = {func = 'piss', args = {''}}
        },
    0, 0, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0.635, 0.525, 'game.camOther')
    
    ToolBox.Functions.Button.Make('test5', (getProperty('sttst:spriteHolder.width')-216.5)/2+20, 0, 'Animated: FALSE', nil, Btncolor, 20, 
        {
            [1] = {func = 'callHaxe', cont = 'animSection = !animSection;'},
        },
    0, -3, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0.5, 0.35, 'game.camOther')
end

function onUpdate()
    runHaxeCode([[
        if (animSection)
            test5.label.text = "Animated: TRUE";
        else
            test5.label.text = "Animated: FALSE";
    ]])
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.X') then
        restartSong(true)
    end
    runHaxeCode('PlayState.instance.callOnLuas("displayToHolder", [test.text, test2.text, test3.text, animSection]);')
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') then
        dataBase.saveData('stageEditor', 'songTime', getSoundTime('streetMusic'))
        soundFadeOut('streetMusic', 1, 0)
        loadSong('mainEditor')
    end
    if keyboardJustPressed('ENTER') and Cheryl.tutorialSteps < 13 then
        Cheryl.switchStep(1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end
end

multEqual = function(v, ...)
    if v == ... then return true end
end

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

function fileExistsMultiPaths(path)
    local paths = {
        'mods/images/',
        'assets/images/',
        'assets/shared/images/'
    }
    for i = 1, #paths do
        if file_exists(paths[i]..path) then
            return true
        end
    end
end

function displayToHolder(tag, path, camera, animated)
    if fileExistsMultiPaths(path..'.png') then
        ToolBox.Functions.Make_Quick.Sprite('display__0__', path, 0, 0, 'camOther', true, false, animated)
        if getProperty('display__0__.width') > getProperty('sttst:spriteHolder.width') or getProperty('display__0__.height') > getProperty('sttst:spriteHolder.height') then
            fixScale('sttst:spriteHolder', 'display__0__', -100)
        else
            scaleObject('display__0__', 1, 1)
        end
        setProperty('display__0__.x', getProperty('sttst:spriteHolder.x')+getProperty('sttst:spriteHolder.width')/2-getProperty('display__0__.width')/2)
        setProperty('display__0__.y', getProperty('sttst:spriteHolder.y')+getProperty('sttst:spriteHolder.height')/2-getProperty('display__0__.height')/2)
    end
end

function fixScale(sprite1, sprite2, mult)
    setGraphicSize(sprite2, getProperty(sprite1..'.width')+mult, getProperty(sprite1..'.height')+mult)
    updateHitbox(sprite2)
    local ratio =  math.min(getProperty(sprite2..'.scale.x'), getProperty(sprite2..'.scale.y'))
    scaleObject(sprite2, ratio, ratio)
end


function piss()
    if Tutorial and Cheryl.tutorialSteps == 13 then
        Cheryl.switchStep(1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end
end