local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local ToolBox = dofile('mods'..getModDir()..'scripts/Stage-Editor/ToolBox-Sublime.lua')
local dataBase = dofile('mods'..getModDir()..'scripts/dataBase.lua')
local Cheryl = dofile('mods'..getModDir()..'scripts/Stage-Editor/Cheryl.lua')
local Make = {}

local song = (ToolBox['Variables'].preferences.darkMode and 'Street Night' or 'Street Day MIX')
local Btnmultiplier = -7
local Btnfolder = (ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')
local Btncolor = (ToolBox['Variables'].preferences.darkMode and 'a2fffd' or 'ffffff')
local leColour = (ToolBox['Variables'].preferences.darkMode and '31284a' or 'ff465b')

local Tutorial = ToolBox.Variables.Tutorial

function Make:AllMainButtons()
    ToolBox['Functions']['Button'].Make('main_PlusButton', 0, 300, '+', nil, Btncolor, 105, 
    {
        [1] = {func = 'Button_MainTransition', args = {''}},
        [2] = {func = 'callHaxe', cont = 'FlxTween.tween(main_PlusButton.label, {angle: (main_PlusButton.label.angle == 0 ? 360 : 0)}, 0.3, {ease: FlxEase.elasticOut});'}
    },
    0, Btnmultiplier, 'stageEditor-Assets/buttons/'..Btnfolder..'/Small-Button', 0.39, 0.39, 'game.camOther')

    ToolBox['Functions']['Button'].Make('makeAnimation', 0, 300, 'Animation', nil, Btncolor, 16, 
    {
        [1] = {func = 'loadSong2', args = {'makeAnimation'}},
        [2] = {func = 'soundFadeOut', args = {'streetMusic', 1, 0}}
    },
    0, 0, 'stageEditor-Assets/buttons/'..Btnfolder..'/Small-Button', 0.29, 0.29, 'game.camOther')

    ToolBox['Functions']['Button'].Make('removeButton', 0, 300, 'Remove', nil, Btncolor, 16, 
    {
        [1] = {func = 'removeObject', args = {''}}
    },
    0, 0, 'stageEditor-Assets/buttons/'..Btnfolder..'/Small-Button', 0.29, 0.29, 'game.camOther')
    
    openTheButtons('dad', true)
end

local butt = false
local allowedSteps = {[0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [44] = true, [45] = true, [46] = true, [47] = true, [48] = true}

function loadSong2(song, difficulty)
    dataBase.saveData('stageEditor', 'songTime', getSoundTime('streetMusic'))
    loadSong(song, difficulty)
end

local isOpen = false
buttonMade = false

function Button_MainTransition()
    if not Cheryl.Blah(6) then return end
    if not isOpen then
        if Tutorial and Cheryl.tutorialSteps == 6 or Cheryl.tutorialSteps == 14 or Cheryl.tutorialSteps == 23 or Cheryl.tutorialSteps == 35 then
            Cheryl.switchStep(1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
        end
        if not buttonMade then
            ToolBox['Functions']['Button'].Make('main_Test', 0, 300, '.PNG', nil, Btncolor, 25, 
            {
                [1] = {func = 'loadSong2', args = {'makeluasprite'}},
                [2] = {func = 'soundFadeOut', args = {'streetMusic', 1, 0}}
            },
            0, 0, 'stageEditor-Assets/buttons/'..Btnfolder..'/Small-Button', 0.29, 0.29, 'game.camOther')

            ToolBox['Functions']['Button'].Make('makeGraphic', 0, 300, '???', nil, Btncolor, 35, 
            {
                [1] = {func = 'loadSong2', args = {'makegraphic'}},
                [2] = {func = 'soundFadeOut', args = {'streetMusic', 1, 0}}
            },
            0, 0, 'stageEditor-Assets/buttons/'..Btnfolder..'/Small-Button', 0.29, 0.29, 'game.camOther')

            ToolBox['Functions']['Button'].Make('makeText', 0, 300, '.TXT', nil, Btncolor, 32, 
            {
                [1] = {func = 'loadSong2', args = {'makeLuaText'}},
                [2] = {func = 'soundFadeOut', args = {'streetMusic', 1, 0}}
            },
            0, 0, 'stageEditor-Assets/buttons/'..Btnfolder..'/Small-Button', 0.29, 0.29, 'game.camOther')

            ToolBox['Functions']['Button'].Make('makeEvent', 0, 300, 'EVENT', nil, Btncolor, 25, 
            {
                [1] = {func = 'loadSong2', args = {'makeEvent'}},
                [2] = {func = 'soundFadeOut', args = {'streetMusic', 1, 0}}
            },
            0, 0, 'stageEditor-Assets/buttons/'..Btnfolder..'/Small-Button', 0.29, 0.29, 'game.camOther')
            ToolBox['Functions']['Button'].Make('moreProperties', 0, 300, 'Property', nil, Btncolor, 16, 
            {
                [1] = {func = 'loadSong2', args = {'moreProperties'}},
                [2] = {func = 'soundFadeOut', args = {'streetMusic', 1, 0}}
            },
            0, 0, 'stageEditor-Assets/buttons/'..Btnfolder..'/Small-Button', 0.29, 0.29, 'game.camOther')
            runHaxeCode([[
                main_Test.alpha = 0;
                FlxTween.tween(main_Test, {y: 140, angle: 360, alpha: 1}, 0.5, {ease: FlxEase.elasticOut});
                makeGraphic.alpha = 0;
                FlxTween.tween(makeGraphic, {x: 120, y: 190, angle: 360, alpha: 1}, 0.5, {ease: FlxEase.elasticOut});
                makeText.alpha = 0;
                FlxTween.tween(makeText, {x: 150, y: 310, angle: 360, alpha: 1}, 0.5, {ease: FlxEase.elasticOut});
                makeEvent.alpha = 0;
                FlxTween.tween(makeEvent, {x: 120, y: 430, angle: 360, alpha: 1}, 0.5, {ease: FlxEase.elasticOut});
                moreProperties.alpha = 0;
                FlxTween.tween(moreProperties, {y: 480, angle: 360, alpha: 1}, 0.5, {ease: FlxEase.elasticOut});
            ]])
            buttonMade = true
            isOpen = true
        end
    else
        runHaxeCode([[
            FlxTween.tween(makeGraphic, {x: 0, y: 300, angle: 0, alpha: 0}, 0.3, {ease: FlxEase.elasticOut});
            FlxTween.tween(makeText, {x: 0, y: 300, angle: 0, alpha: 0}, 0.3, {ease: FlxEase.elasticOut});
            FlxTween.tween(moreProperties, {x: 0, y: 300, angle: 0, alpha: 0}, 0.3, {ease: FlxEase.elasticOut});
            FlxTween.tween(makeEvent, {x: 0, y: 300, angle: 0, alpha: 0}, 0.3, {ease: FlxEase.elasticOut});
            FlxTween.tween(main_Test, {x: 0, y: 300, angle: 0, alpha: 0}, 0.3, {ease: FlxEase.elasticOut, onComplete: function(ass){
                makeGraphic.destroy();
                game.remove(makeGraphic);
                makeText.destroy();
                game.remove(makeText);
                makeEvent.destroy();
                game.remove(makeEvent);
                moreProperties.destroy();
                game.remove(moreProperties);
                main_Test.destroy();
                game.remove(main_Test);
                PlayState.instance.setOnLuas("buttonMade", false);
            }});
        ]])
        isOpen = false
    end
end
if not dataBase.storageExists('stageEditor') then
    dataBase.newStorage('stageEditor')
    dataBase.saveData('stageEditor', 'songTime', 0)
    dataBase.saveData('stageEditor', 'progressOfEditing', false)
end

local function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end   

-- function onCreate()
--     addHaxeLibrary('FlxCamera', 'flixel')
--     runHaxeCode('var camBoton = new FlxCamera();\n camBoton.bgColor = 0x00000000;\n setVar("camButton", camBoton);')
-- end

function onStartCountdown() 
    if buildTarget == 'mobile' then
        while true do-- ITS CORN :D a big lump with knobs, it has the juice
            debugPrint('hi')
        end
    end 

    if Tutorial then
        Cheryl.Spawn()
        local keys = {}
        for _, __ in pairs(ToolBox.Variables.preferences.keyboard) do table.insert(keys, _) end
        Cheryl.stepDialogue = {
            [0] = 'Hello '..getUserName()..' welcome to Cherry\'s LUA Stage editor\n>\n',
            [1] = 'Press "P"\nto toggle the Pixel Stage.\n>\n',
            [2] = 'Press "T" to toggle between objects from the left side.\nPress "Y" to toggle between objects from the right side.\n>\n',
            [3] = 'Press "M" to increase the speed.\nPress "L" to decrease the speed.\n>\n',
            [4] = 'Press '..(table.concat(keys, ', '))..'\nor drag the current selected object\nto move the selected object.\n>\n',
            [5] = 'Press "I" to increase the zoom.\nPress "O" to decrease the zoom.\n>\n',
            [6] = 'Press the button with a plus sign on it\nto open another set of buttons\n>\n',
            [7] = 'Press .PNG\nto open the makeLuaSprite section.\n',
            [14] = 'Press the plus button again\nto open another set of buttons.\n>\n',
            [15] = 'Press Graphic\nto open the makeGraphic section.\n',
            [23] = 'Press the plus button again\nto open another set of buttons.\n>\n',
            [24] = 'Press .TXT\nto open makeLuaText section\n.\n',
            [35] = 'Press the plus button again\nto open another set of buttons.\n>\n',
            [36] = 'Press Property\nto open extraProperties section\n.\n',
            [44] = 'Press "ENTER" if you want to save your stage.\n',
            [45] = 'Press LEFT, RIGHT, UP or DOWN\nto move the display camera\n(does not affect the stage)\n>\n',
            [46] = 'Hold "Shift" and press LEFT, RIGHT, UP or DOWN \nto move character\'s focus camera\n>\n',
            [47] = 'Right click on the curselected sprite to either\nRemove it or make an animation\n>\n',
            [48] = 'These are the basics for now!\nRemember to read the README.md file for more information.\n>\n'
        }
        if dataBase.getData('User_Data', 'Language') == 'Spanish' then
            Cheryl.stepDialogue = {
                [0] = 'Hola, '..getUserName()..'. Te presento el editor de escenarios LUA de Cherry.\n>\n',
                [1] = 'Presiona "P"\npara alternar si es un escenario pixel.\n>\n',
                [2] = 'Presiona "T" para alternar entre los objetos de la izquierda.\nPresiona "Y" para alternar entre los objetos de la derecha.\n>\n',
                [3] = 'Presiona "M" para incrementar la velocidad.\nPresiona "L" para reducir la velocidad.\n>\n',
                [4] = 'Presiona '..(table.concat(keys, ', '))..'\no arrastra el objeto seleccionado\npara moverlo.\n>\n',
                [5] = 'Presiona "I" para incrementar el zoom.\nPresiona "O" para reducir el zoom.\n>\n',
                [6] = 'Presiona el botón con una cruz\npara mostrar más botones.\n>\n',
                [7] = 'Presiona .PNG\npara abrir la sección makeLuaSprite (crear sprite).\n',
                [14] = 'Presiona el botón con una cruz otra vez\n para mostrar más botones.\n>\n',
                [15] = 'Presiona Graphic\npara ir a la sección makeGraphic (crear gráfico).\n',
                [23] = 'Presiona el botón con una cruz otra vez\npara abrir otro set de botones.\n>\n',
                [24] = 'Presiona .TXT\npara abrir la sección makeLuaText (crear texto).\n.\n',
                [35] = 'Presiona el botón con una cruz otra vez\npara abrir otro set de botones.\n>\n',
                [36] = 'Presiona Property\npara abrir la sección extraProperties (propiedades)\n.\n',
                [44] = 'Presiona "ENTER" (Intro) si quieres guardar tu escenario.\n',
                [45] = 'Presiona IZQUIERDA, DERECHA, ARRIBA or ABAJO\npara mover la cámara de ejemplo\n(no afecta el producto final)\n>\n',
                [46] = 'Mantén "Shift" y presiona IZQUIERDA, DERECHA,\nARRIBA o ABAJO\npara mover la posición de cámara del personaje.\n>\n',
                [47] = 'Click derecho en el sprite seleccionado para \nquitarlo o añadirle una animación.\n>\n',
                [48] = '¡Estas fueron las básicas por ahora!\nNo te olvides de leer README.md para más información.\n>\n'
            }
        end
        Cheryl.switchStep(dataBase.getData('Cheryl', 'tutorialSteps') ~= nil and dataBase.getData('Cheryl', 'tutorialSteps') or 0, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    else
        Cheryl.tutorialFinished = true
    end
    addHaxeLibrary('Sound', 'openfl.media')
    luaDebugMode = true
    runHaxeCode([[
        FlxG.stage.window.onDropFile.add((songPath:String) -> {
			songPath = StringTools.replace(songPath, '\\', '/');
			PlayState.instance.modchartSounds.get("streetMusic").fadeOut(0.7, 0, function(tween){
				PlayState.instance.modchartSounds.get("streetMusic").stop();
				var soundFile = Sound.fromFile(songPath);
				PlayState.instance.modchartSounds.set("streetMusic", FlxG.sound.play(soundFile, 0.8, true));
				PlayState.instance.modchartSounds.get("streetMusic").fadeIn(1, 0, 0.7);
			});
		});
    ]])
    initFrames()

    if dataBase.getData('stageEditor', 'songTime') >= 163984 then
        dataBase.saveData('stageEditor', 'songTime', 0)
    end
    playSound(song, 0, 'streetMusic')
    ToolBox.Functions.loopSound('streetMusic', song, true, 1, 0, 0.6)
    soundFadeIn('streetMusic', 1, 0, 0.6)

    if dataBase.getData('stageEditor', 'songTime') ~= nil then setSoundTime('streetMusic', dataBase.getData('stageEditor', 'songTime')) end

    luaDebugMode = true
    if file_exists('mods/stages/'..dataBase.getData('User_Data', 'StageName')..'.lua') and not dataBase.getData('stageEditor', 'progressOfEditing') then
        local piss = dofile('mods/stages/'..dataBase.getData('User_Data', 'StageName')..'.lua')
        if piss ~= nil then
            if piss.newObjects ~= nil then
                ToolBox.Functions.LoadData(dataBase.getData('User_Data', 'StageName'))
            else
                ToolBox.Functions.LoadData2(dataBase.getData('User_Data', 'StageName'))
            end
        else
            ToolBox.Functions.LoadData2(dataBase.getData('User_Data', 'StageName'))
        end
        dataBase.saveData('stageEditor', 'progressOfEditing', true)
    end
    initObjects()
    setPropertyFromClass('flixel.FlxG', 'state.camGame.bgColor', getColorFromHex(leColour))
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
    addHaxeLibrary('FlxText', 'flixel.text')
    runHaxeCode(
        'curObjProperties = new FlxText(0, 0, 0, "N/A", 30, false);\ncurObjProperties.cameras = [game.camOther];\ngame.add(curObjProperties);\ncurObjProperties.alignment = "center";\ncurObjProperties.font = Paths.font("reglisse2.otf");\ncurObjProperties.color = 0xFF'..Btncolor..';'
    )
    runHaxeCode( 
        'otherObjProperties = new FlxText(68, 0, 0, "N/A", 30, false);\notherObjProperties.cameras = [game.camOther];\ngame.add(otherObjProperties);\notherObjProperties.font = Paths.font("reglisse2.otf");\notherObjProperties.color = 0xFF'..Btncolor..';'
    )
    Make:AllMainButtons()
    return Function_Stop
end

function onUpdate(elapsed)
    if getSoundTime('streetMusic') == 163984 then
        onSoundFinished('streetMusic')
    end
    -- dataBase.getData(scriptName:match("[^/]*.lua$"):sub(1, -5)
    if keyboardJustPressed('X') then
        restartSong(true)
    end
    if keyboardJustPressed('ENTER') then
        if Cheryl.tutorialFinished then
            ToolBox.Functions.Save.Lua(dataBase.getData('User_Data', 'StageName'))
            ToolBox.Functions.Save.Json(dataBase.getData('User_Data', 'StageName'))
            playSound('confirmMenu')
            customDebugPrint('Stage Has Been Saved!', ToolBox.Variables.preferences.darkMode and '352040' or 'ffffff', 28, ToolBox.Variables.preferences.font, ToolBox.Variables.preferences.darkMode and 'c7f9f0' or 'ff7c6a', 2)
        else
            if allowedSteps[Cheryl.tutorialSteps] then Cheryl.switchStep(1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor}) end
            if Cheryl.tutorialSteps == 49 then
                dataBase.changeVariable('User_Data', 'Tutorial', nil, nil, nil, nil, nil, false)
                Cheryl.Despawn()
                Cheryl.tutorialFinished = true
                Tutorial = false
            end
        end
    end
    if keyboardJustPressed('P') and Cheryl.Blah(1) then
        ToolBox.Data.isPixelStage = not ToolBox.Data.isPixelStage
        dataBase.changeVariable('ToolBox', 'Data', 'isPixelStage', nil, nil, nil, nil, ToolBox.Data.isPixelStage)
    end

    if keyboardJustPressed('DELETE') then
        removeObject()
    end

    if keyboardJustPressed('ESCAPE') then
        setPropertyFromClass('PlayState', 'chartingMode', false)
        setPropertyFromClass('flixel.FlxG', 'state.camGame.bgColor', getColorFromHex('000000'))
        endSong(true) -- i wont care anymore i will update this soon mfs
        dataBase.deleteStorage('ToolBox')
        dataBase.deleteStorage('stageEditor')
    end
    if keyboardJustPressed('T') and Cheryl.Blah(2) then
        ToolBox.Functions['Change']['Object'](1)
    end
    if keyboardJustPressed('Y') and Cheryl.Blah(2) then
        ToolBox.Functions['Change']['Object'](-1)
    end
    if keyboardJustPressed('M') and Cheryl.Blah(3) then
        ToolBox.Functions['Change']['Speed'](1)
    end
    if keyboardJustPressed('L') and Cheryl.Blah(3) then
        ToolBox.Functions['Change']['Speed'](-1)
    end
    if keyboardJustPressed('O') and Cheryl.Blah(5) then
        ToolBox.Functions['Change']['Zoom'](-0.1)
    end
    if keyboardJustPressed('I') and Cheryl.Blah(5) then
        ToolBox.Functions['Change']['Zoom'](0.1)
    end
    for _, __ in pairs(ToolBox.Variables.preferences['keyboard']) do
        if keyboardPressed(_) and Cheryl.Blah(4) then
            ToolBox.Functions['Move'].Object(__.x, __.y)
        end
    end
    setProperty('camGame.zoom', ToolBox.Data.defaultZoom)
    ToolBox.Functions['Move'].Camera()
    updateObjectProperties(ToolBox['Data'].curObjects[ToolBox['Data'].curObj])
    local detectedCamera = ToolBox['Data'].newObjects[ToolBox['Data'].curObjects[ToolBox['Data'].curObj]] ~= nil and ToolBox['Data'].newObjects[ToolBox['Data'].curObjects[ToolBox['Data'].curObj]].camera or 'game'

    if ToolBox.Functions.mouseOverlaps(ToolBox['Data'].curObjects[ToolBox['Data'].curObj], detectedCamera) and not isOpen --[[getMouseX() >= getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.x')-getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.width') and getMouseX() <= getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.x')+getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.width') and getMouseX() >= getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.y')-getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.height') and getMouseY() <= getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.y')+getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.height')]] then
        if mousePressed('left') and butt then
            openTheButtons(ToolBox['Data'].curObjects[ToolBox['Data'].curObj], true)
            setProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.x', getMouseX(detectedCamera)-getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.width')/2)
            setProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.y', getMouseY(detectedCamera)-getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.height')/2)
        end
        if mouseClicked('right') and ToolBox.Data.charData[ToolBox['Data'].curObjects[ToolBox['Data'].curObj]] == nil then
            openTheButtons(ToolBox['Data'].curObjects[ToolBox['Data'].curObj])
        end
    end
    runHaxeCode('curObjProperties.text = "'..ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'\\nX:'..getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.x')..'\\nY:'..getProperty(ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'.y')..'\\n";')
    for _, __ in pairs({'dad', 'gf', 'boyfriend'}) do
        if ToolBox['Data'].curObjects[ToolBox['Data'].curObj] == __ then
            if keyboardPressed('SHIFT') then
                ToolBox.Functions.Move.Camera2(ToolBox['Data'].curObjects[ToolBox['Data'].curObj])
                runHaxeCode('curObjProperties.text = "'..ToolBox['Data'].curObjects[ToolBox['Data'].curObj]..'\\nCamera_X:'..ToolBox['Data'].charData[ToolBox['Data'].curObjects[ToolBox['Data'].curObj]].camPos.x..'\\nCamera_Y:'..ToolBox['Data'].charData[ToolBox['Data'].curObjects[ToolBox['Data'].curObj]].camPos.y..'\\n";')
            end
        end
        ToolBox.Functions.multiSet(__..'_frame', {x = getProperty(__..'.x'), y = getProperty(__..'.y')})
    end
    runHaxeCode('otherObjProperties.text = "IsPixelStage: '..tostring(ToolBox['Data'].isPixelStage)..'\\nMovement Speed: '..ToolBox['Data'].defaultSpeed..'\\ndefaultZoom: '..ToolBox['Data'].defaultZoom..'\\n";\notherObjProperties.x = curObjProperties.width+curObjProperties.x+8;')

end

function initObjects()
    local objects = ToolBox.Data.newObjects
    for _, __ in pairs(objects) do
        if not __.isText then
            ToolBox.Functions.Make_Quick.Sprite(_, __.path, __.x, __.y, __.camera, true, __.isGraphic, __.isAnimated, __.width, __.height, __.hex)
        else
            ToolBox.Functions.Make_Quick.Text(_, __.text, __.x, __.y, __.font, __.hex, tonumber(__.size), __.camera, true)
        end
        local cam = 'camGame'
        if __.camera:lower() ~= 'hud' and __.camera:lower() ~= 'camhud' and __.camera:lower() ~= 'camgame' and __.camera:lower() ~= 'game' then cam = 'camHud' end
        setObjectCamera(_, cam) -- cause the buttons will be hidden (making a new camera breaks the game so i was forced to do this)
        setObjectOrder(_, __.order)
        for pr, op in pairs(__.extraProperties) do
            setProperty(_..'.'..pr, op)
        end
        setBlendMode(_, __.blendmode)
    end
    local charData = ToolBox.Data.charData
    for _, __ in pairs(charData) do
        ToolBox.Functions.multiSet(_, {x = __.x, y = __.y})
        for pr, op in pairs(__.extraProperties) do
            setProperty(_..'.'..pr, op)
        end
        setObjectOrder(_, __.order)
        setBlendMode(_, __.blendmode)
    end 
end

function initFrames()
    local chars = {'dad', 'gf', 'boyfriend'}
    for i = 1, #chars do
        ToolBox.Functions.Make_Quick.Sprite(chars[i]..'_frame', '', getProperty(chars[i]..'.x'), getProperty(chars[i]..'.y'), 'game', false, true, false, getProperty(chars[i]..'.width'), getProperty(chars[i]..'.height'), 'd7d7d7')
        setProperty(chars[i]..'_frame.alpha', 0.1)
        addLuaSprite(chars[i]..'_frame', false)
    end
end

function updateObjectProperties(curSelected)
    local props = {'x', 'y'}
    for i = 1, #props do
        if curSelected ~= 'boyfriend' and curSelected ~= 'gf' and curSelected ~= 'dad' then
            if ToolBox.Data.newObjects[curSelected][props[i]] ~= getProperty(curSelected..'.'..props[i]) then
                ToolBox.Data.newObjects[curSelected][props[i]] = getProperty(curSelected..'.'..props[i])
                dataBase.changeVariable('ToolBox', 'Data', 'newObjects', curSelected, props[i], nil, nil, getProperty(curSelected..'.'..props[i]))
            end
        else
            if ToolBox.Data.charData[curSelected][props[i]] ~= getProperty(curSelected..'.'..props[i]) then
                ToolBox.Data.charData[curSelected][props[i]] = getProperty(curSelected..'.'..props[i])
                dataBase.changeVariable('ToolBox', 'Data', 'charData', curSelected, props[i], nil, nil, getProperty(curSelected..'.'..props[i]))
            end
            if ToolBox.Data.charData[curSelected].camPos[props[i]] ~= dataBase.getData('ToolBox', 'Data').charData[curSelected].camPos[props[i]] then
                dataBase.changeVariable('ToolBox', 'Data', 'charData', curSelected, 'camPos', props[i], nil, ToolBox.Data.charData[curSelected].camPos[props[i]])
            end
        end
    end
end

function getUserName()
    return io.popen('echo %USERNAME%'):read("*a")
end

function openTheButtons(object, force)
    if force == nil then
        butt = not butt
    else
        butt = force
    end
    runHaxeCode(
        'removeButton.x = '..getProperty(object..'.x')+getProperty(object..'.width')..';\n'..
        'removeButton.y = '..getProperty(object..'.y')-getProperty(object..'.height')..';\n'..
        'FlxTween.tween(removeButton, {x: '..getProperty(object..'.x')..', y: '..getProperty(object..'.y')..'}, 0.2, {ease: FlxEase.elasticOut});\n'..

        'makeAnimation.x = '..getProperty(object..'.x')+getProperty(object..'.width')..';\n'..
        'makeAnimation.y = '..getProperty(object..'.y')-getProperty(object..'.height')..';\n'..
        'FlxTween.tween(makeAnimation, {x: '..(getProperty(object..'.x')-35)..', y: '..(getProperty(object..'.y')+90)..'}, 0.2, {ease: FlxEase.elasticOut});\n'..
        'removeButton.active = '..tostring(not butt)..';\n'..
        'makeAnimation.active = '..tostring(not butt)..';\n'..

        'removeButton.visible = '..tostring(not butt)..';\n'..
        'makeAnimation.visible = '..tostring(not butt)..';\n'
    )
end

function removeObject()
    local crazy = ToolBox['Data'].curObj
    ToolBox['Data'].curObj = 1
    if ToolBox['Data'].newObjects[ToolBox['Data'].curObjects[crazy]].isText then
        removeLuaText(ToolBox['Data'].curObjects[crazy])
    else
        removeLuaSprite(ToolBox['Data'].curObjects[crazy])
    end
    ToolBox['Data'].newObjects[ToolBox['Data'].curObjects[crazy]] = nil
    table.remove(ToolBox['Data'].curObjects, crazy)
    openTheButtons('dad', true)
    dataBase.saveData('ToolBox', 'Data', ToolBox.Data) -- yuh get into it
end