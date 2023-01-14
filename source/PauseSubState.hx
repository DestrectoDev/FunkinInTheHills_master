import flixel.*;
import flixel.text.*;
import flixel.util.*;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.*;
import flixel.system.FlxSound;

class PauseSubState extends MusicBeatSubstate {

    var itemsName:Array<String> = ["resume", "restart", "exit"];
    var itemsGrp:FlxTypedGroup<FNFGraphic>;
    var items:FNFGraphic;

    var pauseSpr:FNFGraphic;

    var curSelected:Int = 0;

    var black:FNFGraphic;
    var pauseMusic:FlxSound;
    
    public static var songName:String = '';
    
    public function new(X, Y) {
     super();
     
     
    pauseMusic = new FlxSound();
    // if(songName != null) {
        // pauseMusic.loadEmbedded(Paths.music(songName), true, true);
    // } else if (songName != 'None') {
        pauseMusic.loadEmbedded(Paths.music("MenuPause"), true, true); // lick ma balls shadow
    // }
    pauseMusic.volume = 0;
    pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

    FlxG.sound.list.add(pauseMusic);

     black = new FNFGraphic(0,0);
     black.createWall(0xFF3B3B3B);
     black.alpha = 0;
     add(black);

     FlxTween.tween(black, {alpha: 0.75}, 0.4, {ease: FlxEase.quartInOut});

     pauseSpr = new FNFGraphic(0, 0);
     pauseSpr.frames = Paths.getSparrowAtlas("pauseAssets/tv", "exe");
     pauseSpr.animation.addByPrefix("loop", "tvxd", 24);
     pauseSpr.playAnim("loop");
     pauseSpr.x = 889.65;
     pauseSpr.y = 21.15;
     pauseSpr.antialiasing = true;
     pauseSpr.updateHitbox();
     pauseSpr.setGraphicSize(Std.int(pauseSpr.width * 1.2));
     add(pauseSpr);

     itemsGrp = new FlxTypedGroup<FNFGraphic>();
     add(itemsGrp);

     for (i in 0...itemsName.length) {
         
         items = new FNFGraphic(0, 0);
         items.frames = Paths.getSparrowAtlas("pauseAssets/" + itemsName[i], "exe");
         items.animation.addByPrefix("idle", itemsName[i] + "0", 24);
         items.animation.addByPrefix("select", itemsName[i] + " select", 24);
         items.playAnim("idle");
         items.ID = i;
         items.antialiasing = true;
         items.updateHitbox();
         items.setGraphicSize(Std.int(items.width * 1.4));

         itemsGrp.add(items);
         rePositionItems(i);
     }
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

        selectionItem();
   }

   function rePositionItems(i) {
    switch (itemsName[i]) {
        case "resume":
            items.x = 118.1;
            items.y = 184.5;
        case "restart":
            items.x = 318.5;  
            items.y = 499.45;
        case "exit":        
            items.x = 824.2; 
            items.y = 388.35;
     }
   }

   function selectionItem(huh:Int = 0) {
        curSelected += huh;

        if (curSelected >= itemsName.length)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = itemsName.length - 1;

        // titi me pregunto
        itemsGrp.forEach(function(spr:FNFGraphic){
            spr.playAnim("idle");

            if (spr.ID == curSelected) {
                spr.playAnim("select");
            }
        });
   }
   
   override public function update(elapsed:Float) {
    super.update(elapsed);
	
    if (pauseMusic.volume < 0.5)
        pauseMusic.volume += 0.01 * elapsed;

    if (FlxG.keys.justPressed.Q){
        PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
        PlayState.changedDifficulty = true;
        PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
        PlayState.instance.botplayTxt.alpha = 1;
        PlayState.instance.botplaySine = 0;
    }

    if (controls.UI_LEFT_P || controls.UI_UP_P)
        selectionItem(-1);

    if (controls.UI_RIGHT_P || controls.UI_DOWN_P)
        selectionItem(1);

    if (controls.ACCEPT) {
      switch (itemsName[curSelected]){
        case "restart":
            trace("reset!");
            restartSong();
            //    FlxG.resetState();
        case "resume":
            trace("resume!");
            close();
		    // PlayState.instance.genShader(PlayState.leShader, FlxG.save.data.shaders, "dark-rain", true);
            FlxG.camera.filtersEnabled = FlxG.save.data.shader;
            FlxG.game.filtersEnabled = FlxG.save.data.shader;
        case "exit":        
            PlayState.deathCounter = 0;
            PlayState.seenCutscene = false;

            WeekData.loadTheFirstEnabledMod();
            if(PlayState.isStoryMode) {
                MusicBeatState.switchState(new StoryMenuState());
            } else {
                MusicBeatState.switchState(new FreeplayState());
            }
            PlayState.cancelMusicFadeTween();
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
            PlayState.changedDifficulty = false;
            PlayState.chartingMode = false;
      }
    }
  }
  override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}
  public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}
}