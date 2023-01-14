-- A BIG SHIIT

-- local directory = "stages/back_back_trees"
-- function onCreate()
-- 	-- background shit
-- 	makeLuaSprite('tree', "stages/dark-rain/back_back_trees", -193.25, 127.45);
-- 	setScrollFactor('tree', 0.8, 0.8);

-- 	makeLuaSprite('floor', directory + 'nsonic-floor', -117.9, 927.25);
-- 	setScrollFactor('floor', 0.9, 0.9);
-- 	scaleObject("floor", 1.4, 1, false);

-- 	makeLuaSprite('treefront', directory + 'nsonic_tree', -86.4, -160.5);
-- 	-- setScrollFactor('darkness', 1, 1);
-- 	scaleObject("treefront", 0.8, 0.8, false);

-- 	addLuaSprite('tree', false);
-- 	addLuaSprite('floor', false);
-- 	addLuaSprite('treefront', false);

-- 	makeAnimatedLuaSprite("cumCloud", directory + "cumrain", -88.6, -76.3, "sparrow");
-- 	addAnimationByPrefix("cumCloud", "rain", "rain", 24, true);
-- 	playAnim("cumCloud", "rain", false, false, 0);

-- 	addLuaSprite("cumCloud", true);
-- 	-- lick ma balls author -- close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
-- end	

-- local alphaShit = 1.0;
-- local alphaDir = 0.1;

-- function onBeatHit() 
--     if curBeat % 4 == 0 then
-- 		alphaDir = alphaShit;
-- 	else
-- 		alphaShit = alphaDir;
-- 	end

-- 	doTweenAlpha("cumalpha", "cumCloud", alphaDir, stepCrochet*0.005, "circInOut");

-- end