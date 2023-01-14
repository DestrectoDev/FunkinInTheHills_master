local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local ToolBox = dofile('mods'..getModDir()..'scripts/Stage-Editor/ToolBox-Sublime.lua')
local mode = (ToolBox['Variables'].preferences.darkMode)
local dataBase = dofile('mods'..getModDir()..'scripts/dataBase.lua')
local Btncolor = (mode and 'a2fffd' or 'ffffff')
local leColour = mode and '31284a' or 'ff3a46'
local song = (mode and 'Street Night' or 'Street Day MIX')
local _Groups = {}
local boing = false

local curSelected = 1
local settingsStuff = {
    KeyBoard = {
        Current = 1,
        Possibles = {'Qwerty', 'Azerty'}
    },
    DarkMode = {
        Current = 1,
        Possibles = {true, false}
    },
    Font = {
        Current = 1,
        Possibles = {'albasuper.ttf', 'fredoka.ttf', 'albam.TTF'}
    },
    Language = {
        Current = 1,
        Possibles = {'English', 'Spanish'}
    }
}
local settingsStuffX = {'KeyBoard', 'DarkMode', 'Font', 'Language'}
local function getIndexByKey(table, key) for _, __ in pairs(table) do if __ == key then return _ end end end

function onStartCountdown()
    return Function_Stop
end

function onCreate()
    if buildTarget == 'mobile' then
        os.exit() -- ITS CORN :D a big lump with knobs, it has the juice
    end 
    if not (dataBase.getData('User_Data', 'DarkMode')) then
        settingsStuff.DarkMode.Current = 2
    end
    if (dataBase.getData('User_Data', 'KeyBoard').Q ~= nil) then
        settingsStuff.KeyBoard.Current = 2
    end
    settingsStuff.Font.Current = getIndexByKey(settingsStuff.Font.Possibles, dataBase.getData('User_Data', 'Font'))
    settingsStuff.Language.Current = getIndexByKey(settingsStuff.Language.Possibles, dataBase.getData('User_Data', 'Language'))
    debugPrint(settingsStuff.Language)

    luaDebugMode = true
    setPropertyFromClass("flixel.FlxG", "mouse.visible", true)
    addHaxeLibrary('FlxTypedGroup', 'flixel.group.FlxGroup')
    addHaxeLibrary('FlxText', 'flixel.text')

    ToolBox.Functions.Make_Quick.Sprite('background', 'stageEditor-Assets/Thumbnail', 0, 0, 'camGame', true)
    ToolBox.Functions.Make_Quick.Sprite('cinBar1', '', 0, 0, 'camOther', true, true, false, screenWidth, 100, '000000')
    ToolBox.Functions.Make_Quick.Sprite('cinBar2', '', 0, screenHeight-100, 'camOther', true, true, false, screenWidth, 100, '000000')
    ToolBox.Functions.Make_Quick.Sprite('BtnHolder', 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Holder-X', 249, 127, 'camGame', true)
    
    ToolBox.Functions.Make_Quick.Text('settings:darkMode', 'DARKMODE: TRUE', 0, 0, 'vcr.ttf', Btncolor, 24, 'camOther', true)
    ToolBox.Functions.Make_Quick.Text('settings:keyBoard', 'KEYBOARD: AZERTY', 0, 0, 'vcr.ttf', Btncolor, 24, 'camOther', true)
    ToolBox.Functions.Make_Quick.Text('settings:font', 'FONT: ALBASUPER.TTF', 0, 0, 'vcr.ttf', Btncolor, 24, 'camOther', true)
    ToolBox.Functions.Make_Quick.Text('settings:language', 'LANGUAGE: ENGLISH', 0, 0, 'vcr.ttf', Btncolor, 24, 'camOther', true)

    setScrollFactor('background', 0, 0)
    setScrollFactor('BtnHolder', 0, 0)
    setGraphicSize('background', screenWidth, screenHeight)

    ToolBox.Functions.Button.Make('Start', 553, 373, 'Start', nil, Btncolor, 27, 
    {
        [1] = {func = 'loadSong', args = {'mainEditor'}}
    },
    0, -7, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Wide-Button', 0.48, 0.42, 'game.camOther')
   
    ToolBox.Functions.Button.Make('switchPage2', screenWidth-70, screenHeight/2, '>', nil, Btncolor, 27, -- naur not me using the same thing from makeAnimation
    {
        [1] = {func = 'switchSectionX', args = {''}}
    },
    0, -7, 'stageEditor-Assets/buttons/'..(ToolBox['Variables'].preferences.darkMode and 'dark' or 'light')..'/Small-Button', 0.2, 0.2, 'game.camOther')

    ToolBox.Functions['TextInput'].Make('StageName', 528, 247, 'Stage Name', 160, 24, nil, Btncolor, 'stageEditor-Assets/buttons/'..(mode and 'dark' or 'light')..'/Wide-Button', 0, 0, 0.58, 0.55)

    -- runHaxeCode(
    --     [[
    --         setVar("settingsShit2", [
    --             "darkMode" => [true, false],
    --             "KeyBoard" => ["Azerty", "Qwerty"]
    --         ]);
    --         settingsShit = [
    --             'darkMode',
    --             'KeyBoard'
    --         ];
    --         hskb = [
    --             0, 0
    --         ];
    --         settingsGroup = [];

    --         for (i in 0...settingsShit.length-1){
    --             var posi = new FlxText(0, 0, 0, settingsShit[i].toUpperCase()+': NULL', 14);
    --             posi.cameras = [game.camOther];
    --             posi.ID = i;
    --             game.add(posi);
    --             settingsGroup.push(posi);
    --         }

    --         game.addTextToDebug(settingsGroup);
    --         setVar("settingsGroup", settingsGroup);
    --     ]]
    -- )
    -- boing = true
end

local butt = false
function switchSectionX()
    butt = not butt
    if butt then
        runHaxeCode(
            'switchPage2.text = "<";\n'..
            'FlxTween.tween(StageName___BG, {x: FlxG.width*2}, 0.4, {ease: FlxEase.smoothStepInOut});\n'..
            'FlxTween.tween(Start, {x: FlxG.width*2}, 0.4, {ease: FlxEase.smoothStepInOut});\n'..
            'FlxTween.tween(StageName, {x: FlxG.width*2}, 0.4, {ease: FlxEase.smoothStepInOut});\n'
        )
    else
        runHaxeCode(
            'switchPage2.text = ">";\n'..
            'FlxTween.tween(StageName___BG, {x: 528}, 0.4, {ease: FlxEase.smoothStepInOut});\n'..
            'FlxTween.tween(Start, {x: 553}, 0.4, {ease: FlxEase.smoothStepInOut});\n'..
            'FlxTween.tween(StageName, {x: 528+StageName___BG.width/2-80}, 0.4, {ease: FlxEase.smoothStepInOut});\n'
        )
    end
end--game.getLuaObject("BtnHolder").x

function onUpdate(elapsed)
    if butt then
        if keyJustPressed('up') then
            switchSelected(-1)
        end
        if keyJustPressed('down') then
            switchSelected(1)
        end
        if keyJustPressed('right') then
            switchValue(1)
        end
        if keyJustPressed('left') then
            switchValue(-1)
        end
        setProperty('settings:keyBoard.visible', true)
        setProperty('settings:darkMode.visible', true)
        setProperty('settings:font.visible', true)
        setProperty('settings:language.visible', true)

        setTextString('settings:keyBoard', 'KEYBOARD: '.. string.upper(tostring(settingsStuff['KeyBoard'].Possibles[settingsStuff['KeyBoard'].Current])))
        setTextString('settings:darkMode', 'DARKMODE: '.. string.upper(tostring(settingsStuff['DarkMode'].Possibles[settingsStuff['DarkMode'].Current])))
        setTextString('settings:font', 'FONT: '.. string.upper(settingsStuff['Font'].Possibles[settingsStuff['Font'].Current]))
        setTextString('settings:language', 'LANGUAGE: '.. string.upper(settingsStuff['Language'].Possibles[settingsStuff['Language'].Current]))
       
        if dataBase.getData('User_Data', 'KeyBoard') ~= ToolBox.Keys[string.lower(settingsStuff['KeyBoard'].Possibles[settingsStuff['KeyBoard'].Current])] then
            dataBase.changeVariable('User_Data', 'KeyBoard', nil, nil, nil, nil, nil, ToolBox.Keys[string.lower(settingsStuff['KeyBoard'].Possibles[settingsStuff['KeyBoard'].Current])])
        end 
        addCheck('Font')
        addCheck('DarkMode')
        addCheck('Language')
    else
        setProperty('settings:keyBoard.visible', false)
        setProperty('settings:darkMode.visible', false)
        setProperty('settings:font.visible', false)
        setProperty('settings:language.visible', false)
    end

    addCheck2(1, 'keyBoard')
    addCheck2(2, 'darkMode')
    addCheck2(3, 'font')
    addCheck2(4, 'language')

    ToolBox.Functions.multiSet('settings:darkMode', {x = getProperty('BtnHolder.x')+getProperty('BtnHolder.width')/2-getProperty('settings:darkMode.width')/2, y = getProperty('BtnHolder.y')+getProperty('BtnHolder.height')/2-getProperty('settings:darkMode.height')/2})
    ToolBox.Functions.multiSet('settings:keyBoard', {x = getProperty('BtnHolder.x')+getProperty('BtnHolder.width')/2-getProperty('settings:keyBoard.width')/2, y = getProperty('settings:darkMode.y')-getProperty('settings:keyBoard.height')-3})
    ToolBox.Functions.multiSet('settings:language', {x = getProperty('BtnHolder.x')+getProperty('BtnHolder.width')/2-getProperty('settings:language.width')/2, y = getProperty('settings:keyBoard.y')-getProperty('settings:language.height')-3})
    ToolBox.Functions.multiSet('settings:font', {x = getProperty('BtnHolder.x')+getProperty('BtnHolder.width')/2-getProperty('settings:font.width')/2, y = getProperty('settings:language.y')-getProperty('settings:font.height')-3})
    -- if boing then
    --     runHaxeCode(
    --         'settingsGroup.forEach(function(six){\n'.. 
    --             'if (six.ID == '..(curSelected-1)..'){\n'..
    --                 'six.alpha = 1;\n'..
    --                 'if (FlxG.keys.justPressed.LEFT)\n'..
    --                     'switchSwatch(-1);\n'..
    --                 'if (FlxG.keys.justPressed.RIGHT)\n'..
    --                     'switchSwatch(1);\n'..
    --                 'six.text = getVar("settingsShit2")[settingsShit['..(curSelected-1)..']][hskb['..(curSelected-1)..']];\n'..
    --             '}else{\n'..
    --                 'six.alpha = 0.6;\n'..
    --             '}'..
    --         '});'..
    --         'function switchSwatch(who){\n'..
    --             'var piss = getVar("settingsShit2").get(settingsShit['..(curSelected-1)..']);\n'..
    --             'hskb['..(curSelected-1)..'] += who;\n'..
    --             'if (piss['..(curSelected-1)..'] > piss.length-1)'..
    --                 'piss['..(curSelected-1)..'] = 0;\n'..
    --             'else if (hskb['..(curSelected-1)..'] < 0)\n'..
    --                 'hskb['..(curSelected-1)..'] = piss.length-1;'..
    --         '}'
    --     )
    -- end
    runHaxeCode('game.callOnLuas("switchStageName", [StageName.text]);')
end

function switchSelected(x)
    curSelected = curSelected + x
    if curSelected < 1 then
        curSelected = #settingsStuffX
    elseif curSelected > #settingsStuffX then
        curSelected = 1
    end
end

function switchValue(x)
    settingsStuff[settingsStuffX[curSelected]].Current = settingsStuff[settingsStuffX[curSelected]].Current + x
    if settingsStuff[settingsStuffX[curSelected]].Current < 1 then
        settingsStuff[settingsStuffX[curSelected]].Current = #settingsStuff[settingsStuffX[curSelected]].Possibles
    elseif settingsStuff[settingsStuffX[curSelected]].Current > #settingsStuff[settingsStuffX[curSelected]].Possibles then
        settingsStuff[settingsStuffX[curSelected]].Current = 1
    end
end

function switchStageName(stg)
    if dataBase.getData('User_Data', 'StageName') ~= stg then
        dataBase.saveData('User_Data', 'StageName', stg)
    end
end

function addCheck(w)
    if dataBase.getData('User_Data', w) ~= settingsStuff[w].Possibles[settingsStuff[w].Current] then
        dataBase.changeVariable('User_Data', w, nil, nil, nil, nil, nil, settingsStuff[w].Possibles[settingsStuff[w].Current])
    end
end

function addCheck2(w, c)
    if curSelected == w then
        setProperty('settings:'..c..'.alpha', 1)
    else
        setProperty('settings:'..c..'.alpha', 0.6)
    end
end