import flixel.*;
import flixel.util.*;
import flixel.ui.*;
import flixel.text.*;
import flixel.group.FlxGroup.FlxTypedGroup;

class FreePlay extends MusicBeatState{
    var bg:FlxSprite;
    var logo:FlxSprite;
    var songTxt:FlxText;
    
    var songName:FlxText;
    var songs:Array<String> = ["focal", "milf"];    
    var songGrp:FlxTypedGroup<FlxText>;

    var curSelected:Int = 0;

    var bgCam:FlxCamera;

    var diffTxt:FlxText;
    
    var curDiff:Int = 0;

    var s1:FlxText;
    var s2:FlxText;

    override public function create(){
      super.create();

    //   bgCam = new FlxCamera();
    // //   add(bgCam);
    //   var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

    //   for (i in 0...initSonglist.length)
    //   {
    //     var data:Array<String> = initSonglist[i].split(':');
    //     songs.push(new ShitSongData(data[0], Std.parseInt(data[2]), data[1]));
    //   }

      bg = new FlxSprite(0, 0, Paths.image('freeplay/${songs[curSelected]}-bg', "exe"));
      bg.antialiasing = true;
      // bg.cameras = [bgCam];
      bg.updateHitbox();
      bg.screenCenter();
    //   if (songs[curSelected] == "focal"){
        //  bg.setGraphicSize(Std.int(bg.width * 2));
    //   }
      bg.setGraphicSize(Std.int(bg.width / 5));
      bg.scrollFactor.set();
      add(bg);

      logo = new FlxSprite(0, 0, Paths.image('freeplay/${songs[curSelected]}', "exe"));
      logo.antialiasing = true;
      logo.updateHitbox();
      logo.updateFramePixels();
      logo.scale.set(0.3, 0.3);
      logo.scrollFactor.set();
      logo.x = -339;
      logo.y = -332;
      add(logo);

      songTxt = new FlxText(-100, 280, FlxG.width, "SONGS", 25);
      songTxt.scale.set(1.3, 1);
      songTxt.setFormat(Paths.font(/*to define*/"Schluber.ttf"), 45, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
      add(songTxt);


      diffTxt = new FlxText(-90, 230, FlxG.width, "NORMAL", 32);
      diffTxt.setFormat(Paths.font(/*to define*/"Schluber.ttf"), 45, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
      add(diffTxt);

    //   s1 = new FlxText(diffTxt.x + diffTxt.width / 2, diffTxt.y - diffTxt.height * 2, FlxG.width, ">" 32);
      s1 = new FlxText(diffTxt.x + 50, diffTxt.y - 9, FlxG.width, " V", 32);
      s1.setFormat(Paths.font(/*to define*/"Schluber.ttf"), 45, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
      s1.angle = 270;
      s1.flipX = true;
      add(s1);

    //   s2 = new FlxText(diffTxt.x + diffTxt.width / 2, diffTxt.y + diffTxt.height * 2, FlxG.width, ">", 32);
      s2 = new FlxText(diffTxt.x - 50, diffTxt.y, FlxG.width, "V ", 32);
      s2.setFormat(Paths.font(/*to define*/"Schluber.ttf"), 45, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
      s2.angle = 180;
      s2.flipX = false;
      add(s2);

      songGrp = new FlxTypedGroup<FlxText>();
      add(songGrp);

      for (i in 0...songs.length){
         songName = new FlxText(350, 40, FlxG.width, songs[i], 60);
         songName.ID = i;
         songName.setFormat(Paths.font(/*to define*/"Schluber.ttf"), 60, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
         songName.borderSize = 1.23;
         songGrp.add(songName);
      }

      changeDiff(1);
      changeFunction(0);
    }
    override public function update(elapsed:Float){
      super.update(elapsed);

      bg.loadGraphic(Paths.image('freeplay/${songs[curSelected]}-bg', "exe"));
      logo.loadGraphic(Paths.image('freeplay/${songs[curSelected]}-logo', "exe"));

      if (controls.UI_UP_P)
        changeFunction(-1);
      
      if (controls.UI_DOWN_P)
        changeFunction(1);

      if (controls.UI_LEFT_P)
        changeDiff(-1);
      if (controls.UI_RIGHT_P)
        changeDiff(1);

      if (controls.UI_RIGHT){
          s1.scale.set(0.7, 0.7);
          s1.color = FlxColor.YELLOW;
      }
      if (controls.UI_RIGHT_R){
          s1.scale.set(1, 1);
          s1.color = FlxColor.WHITE;
      }
      if (controls.UI_LEFT){
          s2.scale.set(0.7, 0.7);
          s2.color = FlxColor.YELLOW;
      }
      if (controls.UI_LEFT_R){
          s2.scale.set(1, 1);
          s2.color = FlxColor.WHITE;
       }
      if (controls.ACCEPT){
      }
      if (controls.BACK){
        FlxG.switchState(new MainMenuState());
      }
    }
    public function changeFunction(sus:Int = 0){
        curSelected += sus;
    
        if (curSelected >= songs.length)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = songs.length-1;    
    
        for (item in songGrp.members){
           item.visible = false;
        //    item.text -= Std.(" <");
           if (item.ID == curSelected){
              item.visible = true;
           }
        }
     }
    public function changeDiff(sus:Int = 0){
     curDiff += sus;

    if (curDiff >= 2)
        curDiff = 0;
    if (curDiff < 0)
        curDiff = 2;    

    switch (curDiff){
        case 0:
            diffTxt.text = "EASY";
            diffTxt.color = FlxColor.LIME;
        case 1:
            diffTxt.text = "NORMAL";
            diffTxt.color = FlxColor.YELLOW;
        case 2:
            diffTxt.text = "HARD";
            diffTxt.color = FlxColor.RED;
    }

    for (item in songGrp.members){
        item.visible = false;
    //    item.text -= Std.(" <");
        if (item.ID == curSelected){
            item.visible = true;
        }
    }
    }
}
class ShitSongData
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}