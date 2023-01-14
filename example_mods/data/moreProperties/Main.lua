local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local ToolBox = dofile('mods'..getModDir()..'scripts/Stage-Editor/ToolBox-Sublime.lua')
local mode = (ToolBox['Variables'].preferences.darkMode)
local dataBase = dofile('mods'..getModDir()..'scripts/dataBase.lua')
local Btncolor = (mode and 'a2fffd' or 'ffffff')
local leColour = mode and '31284a' or 'ff3a46'
local song = (mode and 'Street Night' or 'Street Day MIX')

local Tutorial = ToolBox.Variables.Tutorial
local Cheryl = dofile('mods'..getModDir()..'scripts/Stage-Editor/Cheryl.lua')


function onStartCountdown()
    playSound(song, 0, 'streetMusic')
    soundFadeIn('streetMusic', 1, 0, 0.6)
    setSoundTime('streetMusic', dataBase.getData('stageEditor', 'songTime'))
    ToolBox.Functions.loopSound('streetMusic', song, true, 1, 0, 0.6)

    if Tutorial and dataBase.getData('Cheryl', 'tutorialSteps') >= 35 and dataBase.getData('Cheryl', 'tutorialSteps') < 44 then
        Cheryl.Spawn()
        Cheryl.stepDialogue = {
            [37] = 'This is the section where you can edit an object\'s properties.\n>\n',
            [38] = 'Type your object\'s tag by clicking on the text field "Object"\nand replacing it with your object tag.\n>\n',
            [39] = 'Select the property you want to change by clicking on the text field "Property"\nand replacing it with the wanted property.\n>\n',
            [40] = 'To view what the property\'s value is\novelap your mouse on the object\na card will pop with some properties of the object\nand the property you selected.\n>\n',
            [41] = 'Select the value by changing the textfield "Value"\'s text\n to the wanted value.\n>\n',
            [42] = 'If you want to change the object\'s order\nchange the text field "Order"\'s text to the wanted order.\n>\n',
            [43] = 'Click "Confirm" button to permenantly change\nthe properties of the object.\n>\n',
            [44] = 'Press "ESCAPE" to return to the main editor\n.\n'
        }
        if dataBase.getData('User_Data', 'Language') == 'Spanish' then
            Cheryl.stepDialogue = {
                [37] = 'Esta es la sección donde puedes editar las propiedades de un objeto.\n>\n',
                [38] = 'Escriba la etiqueta de su objeto haciendo clic en el campo de texto "Object"\ny reemplazándolo con su etiqueta de objeto.\n>\n',
                [39] = 'Seleccione la propiedad que desea cambiar haciendo clic en el campo de texto "Property"\ny reemplazándolo con la propiedad deseada.\n>\n',
                [40] = 'Para ver cuál es el valor de la propiedad\nmueva el mouse sobre el objeto\nuna tarjeta aparecerá con algunas propiedades del objeto\ny la propiedad que seleccionó.\n>\n',
                [41] = 'Seleccione el valor cambiando el texto del campo de texto "Value"\n al valor deseado.\n>\n',
                [42] = 'Si desea cambiar el orden del objeto\ncambie el texto del campo de texto "Order" al orden deseado.\n>\n',
                [43] = 'Haga clic en el botón "Confirm" para cambiar permanentemente\nlas propiedades del objeto.\n>\n',
                [44] = 'Presione "ESCAPE" para regresar al editor principal.\n'
            }
        end
        Cheryl.switchStep(dataBase.getData('Cheryl', 'tutorialSteps')+1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end
    return Function_Stop;
end
function onCreate()
    luaDebugMode = true

    makeLuaSprite('display__0__')

    setPropertyFromClass("ClientPrefs", "hideHud", true)
    setPropertyFromClass("flixel.FlxG", "mouse.visible", true)

    ToolBox.Functions.Make_Quick.Sprite('background', '', 0, 0, 'camGame', true, true, false , 3000, 3000, leColour)
    ToolBox.Functions.Make_Quick.Sprite('gradientHolder1', 'stageEditor-Assets/moreProperties/'..(mode and 'dark' or 'light')..'/gradient', 12, 51, 'camGame', true)
    ToolBox.Functions.Make_Quick.Sprite('gradientHolder2', 'stageEditor-Assets/moreProperties/'..(mode and 'dark' or 'light')..'/gradient', 12, 369, 'camGame', true)
    ToolBox.Functions.Make_Quick.Sprite('spriteHolder', 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Sprite-Displayer', 353, 53, 'camGame', true, false, false)
    ToolBox.Functions.Make_Quick.Sprite('infoCard', 'stageEditor-Assets/moreProperties/'..(mode and 'dark' or 'light')..'/InfoBar', 809, 84, 'camOther', true, false, false)
    
    ToolBox.Functions.Make_Quick.Text('infoTxt', 'NOT FOUND', 0, 0, ToolBox.Variables.preferences.font, Btncolor, 20, 'camOther', true)
    setTextBorder('infoTxt', 2, leColour)
    setTextAlignment('infoTxt', 'Center')

    ToolBox.Functions['TextInput'].Make('objectInput', 57, 61, 'Object', 160, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Wide-Button', 0, -5, 0.535, 0.425)
    ToolBox.Functions['TextInput'].Make('propertyInput', 57, 160, 'Property', 160, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Wide-Button', 0, -5, 0.535, 0.425)
    ToolBox.Functions['TextInput'].Make('valueInput', 57, 259, 'Value', 160, 20, nil, Btncolor, 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Wide-Button', 0, -5, 0.535, 0.425)
    ToolBox.Functions['TextInput'].Make('orderInput', 49, 404, 'Order', 200, 24, nil, Btncolor, 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Small-Button', 0, 0, 0.8, 0.755)

    ToolBox.Functions.Button.Make('Confirm', 1138, 9, 'Confirm', nil, Btncolor, 20, 
    {
        [1] = {func = 'quickConfirm', args = {''}},
        [2] = {func = 'piss4', args = {''}}
    },
    0, -7, 'stageEditor-Assets/buttons/'..(ToolBox.Variables.preferences.darkMode and 'dark' or 'light')..'/Small-Button_Prespective', 1, 1, 'game.camOther')
    
    setScrollFactor('background', 0, 0)
    setScrollFactor('gradientHolder1', 0, 0)
    setScrollFactor('gradientHolder2', 0, 0)
    setScrollFactor('spriteHolder', 0, 0)
    setScrollFactor('infoCard', 0, 0)
end

local displayedObj = 'NOT FOUND'
local infoString = ''
local tableShit 
local theProp
local tip = '\n'

function onUpdate()
    setProperty('infoCard.visible', false)
    setProperty('infoTxt.visible', false)
    runHaxeCode('PlayState.instance.callOnLuas("displayToHolderA", [objectInput.text, propertyInput.text, valueInput.text, orderInput.text]);')

    if displayedObj ~= 'NOT FOUND' then
        if ToolBox.Functions.mouseOverlaps('display__0__') then
            setProperty('infoCard.visible', true)
            setProperty('infoTxt.visible', true)
            infoString = displayedObj..
            '\nCamera:   '..fuck(tableShit.camera, 'camGame')..
            '\nOrder:   '..fuck(tableShit.order, 'Automated')..
            '\nScale:   '..fuck(tableShit.extraProperties['scale.x'], '1')..', '..fuck(tableShit.extraProperties['scale.y'], '1')..
            '\nFlip:   '..fuck(tableShit.extraProperties['flipX'], 'FALSE')..', '..fuck(tableShit.extraProperties['flipY'], 'FALSE')..
            '\nScrollFactor:   '..fuck(tableShit.extraProperties['scrollFactor.x'], 'Default')..', '..fuck(tableShit.extraProperties['scrollFactor.y'], 'Default')..
            '\n'..fuck(theProp, 'None')..':   '..fuck(fuck(tableShit.extraProperties[theProp], nil), ((getProperty('display__0__.'..theProp) ~= 'display__0__.'..theProp) and tostring(getProperty('display__0__.'..theProp)) or (string.lower(theProp) ~= 'blendmode' and 'Property Not Found' or fuck(tableShit.blendmode, 'normal'))))..'\n'
            ..'\n'..tip
            if getTextString('infoTxt') ~= infoString then setTextString('infoTxt', infoString) end
        end
    end
    setProperty('infoTxt.x', getProperty('infoCard.x')+getProperty('infoCard.width')/2-getProperty('infoTxt.width')/2)
    setProperty('infoTxt.y', getProperty('infoCard.y')+getProperty('infoCard.height')/2-getProperty('infoTxt.height')/2+5)
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') then
        dataBase.saveData('stageEditor', 'songTime', getSoundTime('streetMusic'))
        soundFadeOut('streetMusic', 1, 0)
        loadSong('mainEditor')
    end

    if keyboardJustPressed('ENTER') and Tutorial and Cheryl.tutorialSteps < 43 then
        Cheryl.switchStep(1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end
end

function tobool(str)
    if str == 'true' then return true elseif str == 'false' then return false else return nil end
end

function displayToHolderA(object, property, value, order)
    theProp = property
    if property:match("^%s*$") then theProp = 'None' end
    if property == 'cameras' or property == 'camera' then theProp = 'Illegal Action' tip = 'Suggestion:\nRemake The Object\nWith A Different Camera\n' else tip = '\n'  end
    if string.find(value, "'") then
        value = string.gsub(value, "'", '"')
    end
    if not string.find(value, '"') then
        if tonumber(value) ~= nil then value = tonumber(value) elseif tobool(value) ~= nil then value = tobool(value) else value = value end
    end
    for _, __ in pairs(ToolBox.Data.newObjects) do
        -- luaDebugMode = true
        if _ == object then
            displayedObj = object
            tableShit = ToolBox.Data.newObjects[object]
            
            if not __.isText then
                removeLuaText('display__0__')
                ToolBox.Functions.Make_Quick.Sprite('display__0__', __.path, 0, 0, 'camGame', true, __.isGraphic, __.isAnimated, __.width, __.height, __.hex)
            else
                removeLuaSprite('display__0__')
                ToolBox.Functions.Make_Quick.Text('display__0__', __.text, 0, 0, __.font, __.hex, tonumber(__.size), 'camGame', true)
            end
            if not object:match("^%s*$") and object ~= 'Object' then 
                if string.lower(property) ~= 'blendmode' then
                    if property ~= 'camera' and property ~= 'cameras' then -- must change it in makesprite/text/graphic
                        if getProperty('display__0__.'..property) ~= 'display__0__.'..property then ToolBox.Data.newObjects[object].extraProperties[property] = value end
                    end
                else
                    ToolBox.Data.newObjects[object].blendmode = value
                end
                if not order:match("^%s*$") and order ~= 'Order'  then
                    ToolBox.Data.newObjects[object].order = order
                end
            end
            setScrollFactor('display__0__', 0, 0)
            for o, l in pairs(__.extraProperties) do
                if getProperty('display__0__.'..o) ~= 'display__0__.'..o and getProperty('display__0__.'..o) ~= nil then setProperty('display__0__.'..o, l) end
            end
            if string.lower(property) == 'blendmode' then
                setBlendMode('display__0__', value)
            end
        else

        end
    end
    for _, __ in pairs(ToolBox.Data.charData) do
        if _ == object then
            removeLuaText('display__0__')
            local thisVar
            if object == 'boyfriend' then thisVar = 'BOYFRIEND' elseif object == 'dad' then thisVar = 'DADDY_DEAREST' else thisVar = 'GF_assets' end
            ToolBox.Functions.Make_Quick.Sprite('display__0__', 'characters/'..thisVar, 0, 0, 'camGame', true, false, true)
            if property:match("^%s*$") then theProp = 'None' end
            tableShit = ToolBox.Data.charData[object]
            if not object:match("^%s*$") and object ~= 'Object' then
                displayedObj = object
                if not order:match("^%s*$") and order ~= 'Order'  then
                    ToolBox.Data.charData[object].order = order
                end
                if string.lower(property) ~= 'blendmode' then
                    if getProperty(object..'.'..property) ~= object..'.'..property then
                        if property ~= 'camera' or property ~= 'cameras' then
                            ToolBox.Data.charData[object].extraProperties[property] = value
                        end
                    end
                else
                    ToolBox.Data.charData[object].blendmode = value
                end
            end
            setScrollFactor('display__0__', 0, 0)
            for o, l in pairs(__.extraProperties) do
                if getProperty('display__0__.'..o) ~= 'display__0__.'..o and getProperty('display__0__.'..o) ~= nil then setProperty('display__0__.'..o, l) end
            end
            if string.lower(property) == 'blendmode' then
                setBlendMode('display__0__', value)
            end
        end
    end

    if ToolBox.Data.newObjects[object] == nil and ToolBox.Data.charData[object] == nil then
        displayedObj = 'NOT FOUND'
    end

    if ToolBox.Data.newObjects[object] ~= nil or ToolBox.Data.charData[object] ~= nil then
        if getProperty('display__0__.width') > getProperty('spriteHolder.width') or getProperty('display__0__.height') > getProperty('spriteHolder.height') then
            fixScale('spriteHolder', 'display__0__', -100)
        else
            scaleObject('display__0__', 1, 1)
        end
    end
    updateHitbox('display__0__')
    setProperty('display__0__.x', getProperty('spriteHolder.x')+getProperty('spriteHolder.width')/2-getProperty('display__0__.width')/2)
    setProperty('display__0__.y', getProperty('spriteHolder.y')+getProperty('spriteHolder.height')/2-getProperty('display__0__.height')/2)
end

function fuck(f, t)
    return (f ~= nil and (type(f) ~= "boolean" and f or tostring(f)) or t)
end

function fixScale(sprite1, sprite2, mult)
    setGraphicSize(sprite2, getProperty(sprite1..'.width')+mult, getProperty(sprite1..'.height')+mult)
    updateHitbox(sprite2)
    local ratio =  math.min(getProperty(sprite2..'.scale.x'), getProperty(sprite2..'.scale.y'))
    scaleObject(sprite2, ratio, ratio)
end

function quickConfirm()
    if displayedObj ~= 'NOT FOUND' then
        customDebugPrint(displayedObj..' Properties Has Been Changed!', mode and '352040' or 'ffffff', 28, ToolBox.Variables.preferences.font, mode and 'c7f9f0' or 'ff7c6a', 2)
        playSound('confirmMenu', 1)
    else
        customDebugPrint('Object Not Found', mode and '352040' or 'ffffff', 28, ToolBox.Variables.preferences.font, 'ff002f', 2)
        playSound('cancelMenu', 1)
    end
    dataBase.saveData('ToolBox', 'Data', ToolBox.Data)
end

function piss4()
    if Tutorial and Cheryl.tutorialSteps == 43 then
        Cheryl.switchStep(1, 'ffffff', {'0xFF'..leColour, '0xFF'..Btncolor})
    end
end


-- this shit is messy wah wah
-- sry peeps i was in a hurry while making this lov u