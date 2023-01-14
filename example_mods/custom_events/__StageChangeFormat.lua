local removeableObjects = {}
local makeLuaSprite, makeLuaText, makeAnimatedLuaSprite, close, playMusic, playSound, addAnimationByPrefix, playAnim, objectPlayAnimation, setProperty, getProperty, setObjectCamera, setObjectOrder, setTextString
function close(...) return 0 end

playMusic = close playSound = close playAnim = close addAnimationByPrefix = close
objectPlayAnimation = close setProperty = close getProperty = close
setObjectCamera = close setObjectOrder = close setTextString = close


function makeLuaSprite(tag, ...)
    table.insert(removeableObjects, tag)
    getfenv().makeLuaSprite(tag, '', 0, 0) -- so it doesnt break
    makeGraphic(tag, 5, 5, '000000')
end
function makeLuaText(tag, ...)
    table.insert(removeableObjects, tag)
    getfenv().makeLuaText(tag, 'piss', 0, 0, 0)
end
function makeAnimatedLuaSprite(tag, ...)
    table.insert(removeableObjects, tag)
    getfenv().makeAnimatedLuaSprite(tag, 'characters/BOYFRIEND', 0, 0)
end
