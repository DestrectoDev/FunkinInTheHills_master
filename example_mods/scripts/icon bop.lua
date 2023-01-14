local angleshit = 1;
local anglevar = 10;

function onBeatHit()
	if curBeat % 2 == 0 then
		angleshit = anglevar;
	else
		angleshit = -anglevar;
	end
	setProperty('iconP1.angle',-angleshit)
	setProperty('iconP2.angle',angleshit)
	doTweenAngle('turn', 'iconP1', 0, stepCrochet*0.005, 'circOut')
	doTweenX('tuin', 'iconP1', -angleshit, crochet*0.005, 'linear')
	doTweenAngle('tt', 'iconP2', 0, stepCrochet*0.005, 'circOut')
	doTweenX('ttrn', 'iconP2', -angleshit, crochet*0.005, 'linear')
end
	