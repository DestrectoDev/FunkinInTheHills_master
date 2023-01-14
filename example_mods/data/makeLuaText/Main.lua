local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local ToolBox = dofile('mods'..getModDir()..'scripts/Stage-Editor/ToolBox-Sublime.lua')

local mode = (ToolBox['Variables'].preferences.darkMode)

local dataBase = dofile('mods'..getModDir()..'scripts/dataBase.lua')
local Btncolor = (mode and 'a2fffd' or 'ffffff')
local leColour = mode and '31284a' or 'ff3a46'
local song = (ToolBox['Variables'].preferences.darkMode and 'Racing' or 'Street Day MIX')

local Tutorial = ToolBox.Variables.Tutorial
local Cheryl = dofile('mods'..getModDir()..'scripts/Stage-Editor/Cheryl.lua')

function onStartCountdown()
    if Tutorial and dataBase.getData('Cheryl', 'tutorialSteps') >= 24 and dataBase.getData('Cheryl', 'tutorialSteps') < 36 then
        Cheryl.Spawn()
        Cheryl.stepDialogue = {
            [25] = 'This is the section where you can make texts.\nthe text field behind me gives you the ability to type your text there.\n>\n',
            [26] = 'Lets start by giving your text a name.\n>\n',
            [27] = 'To do that click on the text field "Text Tag"\nand replace the text with your text\'s tag.\n>\n',
            [28] = 'Choose a text font by replacing the text\n in the text field "Font" with your font\nor leave it like itself\n to select the default text font.\n>\n',
            [29] = 'Select a camera by putting your camera name in the text field called\n"Camera"\n>\n',
            [30] = 'Select a color and a size by clicking on the "Feather"\nthat displays the current color.\n>\n',
            [31] = 'Select a color by dragging your mouse on the colour wheel\nchoose a size by clicking on the text field "Size" and replacing it with your size.\n>\n',
            [32] = 'Close this by clicking on the feather again.\n>\n',
            [33] = 'Write a text by clicking on the text field "Text"\nand writing your text on it.\n>\n',
            [34] = 'Make your text by clicking the button "Confirm".\n>\n',
            [35] = 'Go back to the main editor by clicking "ESCAPE"\n.\n'
        }
        if dataBase.getData('User_Data', 'Language') == 'Spanish' then
            Cheryl.stepDialogue = {
                [25] = 'Esta es la sección donde puedes hacer textos.\nel campo de texto detrás de mí te permite escribir tu texto.\n>\n',
                [26] = 'Comencemos dando un nombre a su texto.\n>\n',
                [27] = 'Para hacer eso, haga clic en el campo de texto "Text Tag"\ny reemplace el texto con su etiqueta de texto.\n>\n',
                [28] = 'Elija una fuente de texto reemplazando el texto\n en el campo de texto "Font" con su fuente\no déjelo como está\n para seleccionar la fuente de texto predeterminada.\n>\n',
                [29] = 'Seleccione una cámara poniendo el nombre de su cámara en el campo de texto llamado\n"Camera"\n>\n',
                [30] = 'Seleccione un color y un tamaño haciendo clic en la pluma\nque muestra el color actual.\n>\n',
                [31] = 'Seleccione un color arrastrando el mouse sobre la rueda de colores\nelija un tamaño haciendo clic en el campo de texto "Size" y reemplazándolo con su tamaño.\n>\n',
                [32] = 'Cierralo haciendo clic en la pluma nuevamente.\n>\n',
                [33] = 'Escribe un texto haciendo clic en el campo de texto "Text".\n>\n',
                [34] = 'Crea el texto haciendo clic en el botón "Confirmar".\n>\n',
                [35] = 'Regresa al editor principal presionando "ESCAPE".\n.\n'
            }
        end
        Cheryl.switchStep(dataBase.getData('Cheryl', 'tutorialSteps')+1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end
    return Function_Stop;
end

function onCreate()
    setPropertyFromClass("flixel.FlxG", "mouse.visible", true)
    addHaxeLibrary('Std')

    playSound(song, 0, 'streetMusic')
    soundFadeIn('streetMusic', 1, 0, 0.6)
    ToolBox.Functions.loopSound('streetMusic', song, true, 1, 0, 0.6)
    setSoundTime('streetMusic', dataBase.getData('stageEditor', 'songTime'))

    ToolBox.Functions.Make_Quick.Sprite('background', '', 0, 0, 'camGame', true, true, false , 3000, 3000, leColour)
    ToolBox.Functions.Make_Quick.Sprite('Feather-Ink', 'stageEditor-Assets/makeText/'..(mode and '' or 'light')..'/Feather-ink', mode and 62 or 58, mode and 567 or 525, 'camGame', true, false, false)
    ToolBox.Functions.Make_Quick.Sprite('buttonHolder', 'stageEditor-Assets/'..(mode and 'buttons/dark/defaultHolder' or 'buttons/light/Button-Holder'), 289, 55, 'camGame', true, false, false)
    ToolBox.Functions.Make_Quick.Sprite('colourWheel', 'stageEditor-Assets/makeGraphic/'..(mode and 'dark' or 'light')..'/colorWheel', 100, 550, 'camOther', true, false, false)
    ToolBox.Functions.Make_Quick.Sprite('leChose-W', '', getProperty('colourWheel.x')+getProperty('colourWheel.width')/2-2.5, getProperty('colourWheel.y')+getProperty('colourWheel.height')/2-2.5, 'other', true, true, false, 5, 5, '8ef680')
    
    setScrollFactor('background', 0, 0)
    setScrollFactor('buttonHolder', 0, 0)
    setScrollFactor('Feather-Ink', 0, 0)
    
    setProperty('colourWheel.scale.x', 0)
    setProperty('colourWheel.scale.y', 0)

    ToolBox.Functions['TextInput'].Make('textAnalogInput', 637, 27, 'Text', 550, 20, nil, Btncolor, 'stageEditor-Assets/makeText/'..(mode and '' or 'light')..'/textHolder', -10, -310,  1, 1, 'left')
    ToolBox.Functions['TextInput'].Make('textTagInput', 313, 73, 'Text Tag', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.635, 0.525)
    ToolBox.Functions['TextInput'].Make('hexInput', 100, 550, 'ffffff', 240, 1, nil, Btncolor, 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Wide-Button', 0, 0,  0, 0)
    ToolBox.Functions['TextInput'].Make('sizeInput', 100, 550, 'Size', 240, 1, nil, Btncolor, 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Small-Button', 0, 0,  0, 0)
    ToolBox.Functions['TextInput'].Make('fontInput', 313, 192, 'Font', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.635, 0.525)
    ToolBox.Functions['TextInput'].Make('cameraInput', 313, 313, 'Camera', 240, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Wide-Button', 0, -10,  0.635, 0.525)

    ToolBox.Functions.Button.Make('Feather', 31, 45, '', nil, Btncolor, 1, 
        {
            [1] = {func = 'callHaxe', cont = [[
                PlayState.instance.callOnLuas("colourWheelTransition", [textAnalogInput.visible]);
                textAnalogInput.active = !textAnalogInput.active;
                textAnalogInput.visible = !textAnalogInput.visible;
            ]]}
        },
    0, -7, 'stageEditor-Assets/makeText/'..(mode and '' or 'light')..'/Feather', 1, 1, 'game.camOther')

    ToolBox.Functions.Button.Make('Confirm', 313, 434, 'Confirm', nil, Btncolor, 20, 
    {
        [1] = {func = 'callTableFunc', args = {'MakeText', 'nil', 'nil', 'nil', '---@:textTagInput.text', '---@:textAnalogInput.text', '---@:fontInput.text', '---@:hexInput.text', '---@:sizeInput.text', '---@:cameraInput.text'}},
        [2] = {func = 'piss3', args = {''}}
    },
    0, -7, 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Wide-Button', 0.635, 0.525, 'game.camOther')

    runHaxeCode('textAnalogInput.lines = (textAnalogInput___BG.height/textAnalogInput.size)-1; hexInput.active = false; sizeInput.active = false;')
end

function colourWheelTransition(x)
    if x then
        doTweenX('colourWheelOpen1', 'colourWheel.scale', 1, 1, 'elasticOut')
        doTweenY('colourWheelOpen2', 'colourWheel.scale', 1, 1, 'elasticOut')
        doTweenX('colourWheelOpen3', 'colourWheel', 743, 1, 'elasticOut')
        doTweenY('colourWheelOpen4', 'colourWheel', 67, 1, 'elasticOut')
        setProperty('leChose-W.visible', true)
        runHaxeCode([[
            FlxTween.tween(hexInput___BG.scale, {x: 0.68, y: 0.6}, 1, {ease: FlxEase.elasticOut});
            FlxTween.tween(hexInput, {x: 870+hexInput___BG.width/2-hexInput.width/2, y: 604+hexInput___BG.height/2-hexInput.height/2-20, size: 20}, 1, {ease: FlxEase.elasticOut});
            FlxTween.tween(hexInput___BG, {x: 870, y: 604}, 1, {ease: FlxEase.elasticOut});

            FlxTween.tween(sizeInput___BG.scale, {x: 0.45, y: 0.45}, 1, {ease: FlxEase.elasticOut});
            FlxTween.tween(sizeInput, {x: 1106+sizeInput___BG.width/2-sizeInput.width/2, y: 597+sizeInput___BG.height/2-sizeInput.height/2-15, size: 20}, 1, {ease: FlxEase.elasticOut});
            FlxTween.tween(sizeInput___BG, {x: 1106, y: 597}, 1, {ease: FlxEase.elasticOut});

            sizeInput.visible = true;
            hexInput.visible = true;

            hexInput.active = true;
            sizeInput.active = true;
        ]])
    else
        doTweenX('colourWheelOpen1', 'colourWheel.scale', 0, 1, 'elasticOut')
        doTweenY('colourWheelOpen2', 'colourWheel.scale', 0, 1, 'elasticOut')
        doTweenX('colourWheelOpen3', 'colourWheel', 100, 1, 'elasticOut')
        doTweenY('colourWheelOpen4', 'colourWheel', 550, 1, 'elasticOut')
        setProperty('leChose-W.visible', false)
        runHaxeCode([[
            FlxTween.tween(hexInput___BG.scale, {x: 0, y: 0}, 1, {ease: FlxEase.elasticOut});
            FlxTween.tween(hexInput, {x: 100, y: 550, size: 1}, 1, {ease: FlxEase.elasticOut});
            FlxTween.tween(hexInput___BG, {x: 100, y: 550}, 1, {ease: FlxEase.elasticOut});

            FlxTween.tween(sizeInput___BG.scale, {x: 0, y: 0}, 1, {ease: FlxEase.elasticOut});
            FlxTween.tween(sizeInput, {x: 100, y: 550, size: 1}, 1, {ease: FlxEase.elasticOut});
            FlxTween.tween(sizeInput___BG, {x: 100, y: 550}, 1, {ease: FlxEase.elasticOut});

            sizeInput.visible = false;
            hexInput.visible = false;

            hexInput.active = false;
            sizeInput.active = false;
        ]])
    end
end
function onUpdate()
    runHaxeCode("PlayState.instance.callOnLuas('setProperty', ['Feather-Ink.color', Std.parseInt('0xff'+hexInput.text)]); textAnalogInput.color = Std.parseInt('0xff'+hexInput.text);")

    local pixelColor = getPixelColor('colourWheel', getProperty('leChose-W.x')-(getProperty('leChose-W.width')/2)-743, getProperty('leChose-W.y')-(getProperty('leChose-W.height')/2)-getProperty('colourWheel.y'))
    local hexColor = intToHex(pixelColor)
    if ToolBox.Functions.mouseOverlaps('colourWheel', 'other') and getProperty('colourWheel.scale.x') == 1 then
        if mousePressed('left') then
            setProperty('leChose-W.y', getMouseY('other'))
            setProperty('leChose-W.x', getMouseX('other'))
            runHaxeCode('hexInput.text = "'..hexColor..'";')
        end
    end

    if keyboardJustPressed('ENTER') and Tutorial and Cheryl.tutorialSteps < 34 then
        Cheryl.switchStep(1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end

    if Tutorial and Cheryl.tutorialSteps == 31 and getProperty('sttst:Cheryl.x') ~= 0 then
        Cheryl.x = 0
        Cheryl.flip = true
        Cheryl.switchStep(0, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end

    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') then
        dataBase.saveData('stageEditor', 'songTime', getSoundTime('streetMusic'))
        soundFadeOut('streetMusic', 1, 0)
        loadSong('mainEditor')
    end
end
function intToHex(int) return string.format("%06x", bit.band(0xFFFFFF, int)) end

function piss3()
    if Tutorial and Cheryl.tutorialSteps == 34 then
        Cheryl.switchStep(1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end
end