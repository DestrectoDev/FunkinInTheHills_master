local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local ToolBox = dofile('mods'..getModDir()..'scripts/Stage-Editor/ToolBox-Sublime.lua')
local dataBase = dofile('mods'..getModDir()..'scripts/dataBase.lua')
local Btncolor = (ToolBox['Variables'].preferences.darkMode and 'a2fffd' or 'ffffff')
local leColour = ToolBox['Variables'].preferences.darkMode and '31284a' or 'ff3a46'
local song = (ToolBox['Variables'].preferences.darkMode and 'Street Night' or 'Street Day MIX')
local Tutorial = ToolBox.Variables.Tutorial
local Cheryl = dofile('mods'..getModDir()..'scripts/Stage-Editor/Cheryl.lua')

function onStartCountdown()
    return Function_Stop;
end

function onCreate()
    if Tutorial and dataBase.getData('Cheryl', 'tutorialSteps') >= 15 and dataBase.getData('Cheryl', 'tutorialSteps') < 23 then
        Cheryl.Spawn()
        Cheryl.stepDialogue = {
            [16] = 'This is the section where you can make graphics.\nThis box above me will display the color of your graphic.\n>\n',
            [17] = 'Lets start by giving your graphic a name.\n>\n',
            [18] = 'To do that, click on the text field "Graphic Tag"\nand replace the text with your graphic\'s name.\n>\n',
            [19] = 'Choose a height or width by clicking on the text field\n"Height" or "Width".\n>\n',
            [20] = 'Select a camera by putting your camera name in the text field called\n"Camera"\n>\n',
            [21] = 'Select a color by putting a hex code in the text field "000000" a.k.a "Color"\nor dragging your mouse anywhere on the color wheel.\n>\n',
            [22] = 'Make your graphic by clicking "Confirm".\n>\n',
            [23] = 'Click "ESCAPE" to go back to the main editor.\n'
        }
        if dataBase.getData('User_Data', 'Language') == 'Spanish' then
            Cheryl.stepDialogue = {
                [16] = 'Esta es la sección de gráficos\nEsta caja arriba de mí mostrará el color de los gráficos\n>\n',
                [17] = 'Inicia dandole un nombre a tu gráfico.\n>\n',
                [18] = 'Haz clic en "Graphic Tag"\ny escribe el nombre de tu gráfico.\n>\n',
                [19] = 'Escoge un alto y ancho dando clic en "Width" o "Height"\n>\n',
                [20] = 'Escoge una cámara escribiendo su nombre en "Camera"\n>\n',
                [21] = 'Selecciona un color escribiendo en "000000" (color)\no arrastrando tu mouse en la rueda de color.\n>\n',
                [22] = 'Crea el gráfico haciendo clic en "Confirm".\n>\n',
                [23] = 'Presiona "ESCAPE" para volver al editor normal.\n'
            }
        end
        Cheryl.switchStep(dataBase.getData('Cheryl', 'tutorialSteps')+1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end
    addHaxeLibrary('Std')

    playSound(song, 0, 'streetMusic')
    soundFadeIn('streetMusic', 1, 0, 0.6)
    ToolBox.Functions.loopSound('streetMusic', song, true, 1, 0, 0.6)
    setSoundTime('streetMusic', dataBase.getData('stageEditor', 'songTime'))
    
    ToolBox.Functions.Make_Quick.Sprite('background', '', 0, 0, 'camGame', true, true, false, 3000, 3000, leColour)
    ToolBox.Functions.Make_Quick.Sprite('ButtonHolder', 'stageEditor-Assets/'..(ToolBox['Variables'].preferences.darkMode and 'makeGraphic/dark/ButtonHolder' or 'buttons/light/Button-Holder'), 37, 45, 'camGame', true, false, false)
    ToolBox.Functions.Make_Quick.Sprite('colorWheel', 'stageEditor-Assets/makeGraphic/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/colorWheel', 418, 51, 'camGame', true, false, false)
    ToolBox.Functions.Make_Quick.Sprite('graphicDisplayer', '', 1001, 64, 'camGame', true, true, false, 220, 220, 'ffffff')
    ToolBox.Functions.Make_Quick.Sprite('graphicHolder', 'stageEditor-Assets/makeGraphic/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/graphicHolder', 981, 48, 'camGame', true, false, false)
    ToolBox.Functions.Make_Quick.Sprite('leChose-W', '', getProperty('colorWheel.x')+getProperty('colorWheel.width')-2.5, getProperty('colorWheel.y')+getProperty('colorWheel.height')-2.5, 'other', true, true, false, 5, 5, '8ef680')
    
    ToolBox.Functions['TextInput'].Make('hexCodeInput', 466, 479, '000000', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.7, 0.6)
    ToolBox.Functions['TextInput'].Make('graphicTagInput', 45, 96, 'Graphic Tag', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.7, 0.6)
    ToolBox.Functions['TextInput'].Make('cameraInput', 45, 393, 'Camera', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.7, 0.6)
    ToolBox.Functions['TextInput'].Make('widthInput', 45, 238, 'Width', 120, 25, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Small-Button', 0, -5,  0.481, 0.458)
    ToolBox.Functions['TextInput'].Make('heightInput', 202, 238, 'Height', 120, 25, nil, Btncolor, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Small-Button', 0, -5,  0.481, 0.458)
   
    ToolBox.Functions.Button.Make('Confirm', 970, 379, 'Confirm', nil, Btncolor, 22, 
        {
            [1] = {func = 'callTableFunc', args = {'MakeSprite', 'nil', 'nil', 'nil', '---@:graphicTagInput.text', '', '---@:cameraInput.text', false, true, '---@:Std.parseInt(widthInput.text)', '---@:Std.parseInt(heightInput.text)', '---@:hexCodeInput.text'}},
            [2] = {func = 'piss2', args = {''}}
        },
    0, -7, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0.63, 0.6, 'game.camOther')
    
    setScrollFactor('graphicDisplayer', 0, 0)
    setScrollFactor('background', 0, 0)
    setScrollFactor('ButtonHolder', 0, 0)
    setScrollFactor('colorWheel', 0, 0)
    setScrollFactor('graphicHolder', 0, 0)
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
end

function onUpdate()
    runHaxeCode("PlayState.instance.callOnLuas('setProperty', ['graphicDisplayer.color', Std.parseInt('0xff'+hexCodeInput.text)]);")

    local pixelColor = getPixelColor('colorWheel', getProperty('leChose-W.x')-(getProperty('leChose-W.width')/2)-413, getProperty('leChose-W.y')-(getProperty('leChose-W.height')/2)-47)
    local hexColor = intToHex(pixelColor)
    if ToolBox.Functions.mouseOverlaps('colorWheel', 'other') then
        if mousePressed('left') then
            setProperty('leChose-W.y', getMouseY('other'))
            setProperty('leChose-W.x', getMouseX('other'))
            runHaxeCode('hexCodeInput.text = "'..hexColor..'";')
        end
    end

    if Tutorial and Cheryl.tutorialSteps == 22 and getProperty('sttst:Cheryl.x') ~= 0 then
        Cheryl.x = 0
        Cheryl.flip = true
        Cheryl.switchStep(0, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end

    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') then
        dataBase.saveData('stageEditor', 'songTime', getSoundTime('streetMusic'))
        soundFadeOut('streetMusic', 1, 0)
        loadSong('mainEditor')
    end

    if keyboardJustPressed('ENTER') and Tutorial and Cheryl.tutorialSteps < 22 then
        Cheryl.switchStep(1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end

    -- local darknessColor = getPixelColor('Gardiant', getProperty('leChose-G.x')+getProperty('leChose-G.width')/2-600, getProperty('leChose-G.y')+getProperty('leChose-G.height'))
    -- local darknessHex = string.format("%06x", bit.band(0xFFFFFF, darknessColor))
    -- local hextocolor = getColorFromHex(darknessHex)

    -- local darknessRGB = intToRgb(darknessColor)
    -- local pixelRGB = intToRgb(pixelColor)
    -- local light = colorLightning(pixelRGB.R, pixelRGB.G, pixelRGB.B, darknessRGB.R)
    -- setProperty('displayer.color', getColorFromHex(to_hex(light.R, light.G, light.B)))
    -- debugPrint(to_hex(light.R, light.G, light.B)) [[* DARKEN COLOR BETA *]]
end

function piss2()
    if Tutorial and Cheryl.tutorialSteps == 22 then
        Cheryl.switchStep(1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end
end

function intToHex(int) return string.format("%06x", bit.band(0xFFFFFF, int)) end
function to_hex(r, g, b) return string.format('%x', (r * 0x10000) + (g * 0x100) + b) end
function intToRgb(int) return { R = bit.band(bit.rshift(int, 16), 0xff), G = bit.band(bit.rshift(int, 8), 0xff), B = bit.band((int), 0xff) } end
function colorLightning(r, g, b, x) if x ~= 0 then return {R = math.floor(math.min(255, r * (x/255))), G = math.floor(math.min(255, g * (x/255))), B = math.floor(math.min(255, b * (x/255)))} else return {R = 255, G = 255, B = 255} end end