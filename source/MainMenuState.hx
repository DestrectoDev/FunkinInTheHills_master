// CODE MADE BY ASSMANBRUH NO ME ROBES HDP

package;

import flixel.math.FlxPoint;
import haxe.Json;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.math.FlxVelocity;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
// import io.newgrounds.NG;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;

using StringTools;
/**
    Playable Menu SHITASS
**/
class MainMenuState extends MusicBeatState{

  var player:Player;

  var redRing:FlxSprite;

  var ground:FlxSprite;
  var optionsSpr:FlxSprite;
  var mountains:FlxSprite;
  
  var sonic:FlxSprite;

  public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC

  var hitbox:FlxSprite;
  
  override public function create()  {
    super.create();

    CoolUtil.playMenuSong();
    
    ground = new FlxSprite(30, 40);
    ground.frames  = Paths.getSparrowAtlas("menuSprites/floor", "exe");
    ground.animation.addByPrefix("static", "Símbolo 5");
    ground.animation.play("static");
    ground.antialiasing = true;
    ground.scale.set(1.5, 1.5);
    add(ground);

    FlxG.camera.zoom -= 0.13;

    mountains = new FlxSprite(ground.x -20, ground.y);
    mountains.frames = Paths.getSparrowAtlas("menuSprites/mountains", "exe");
    mountains.animation.addByPrefix("idle", "Símbolo 5");
    mountains.animation.play("idle");
    mountains.updateHitbox();
    mountains.immovable = true;
    mountains.antialiasing = true;

    hitbox = new FlxSprite(ground.x - 280, ground.y - 12, Paths.image("menuSprites/mountains-colission", "exe"));
    hitbox.updateHitbox();
    hitbox.immovable = true;
    hitbox.scale.set(Std.int(mountains.width), Std.int(mountains.height));
    // hitbox.visible = false;

    sonic = new FlxSprite(0, 0);
    sonic.frames = Paths.getSparrowAtlas("menuSprites/sonic_exe", "exe");
    sonic.animation.addByPrefix("sonicLAUGH", "sonic rie", 24);
    sonic.animation.addByPrefix("sonicDOWN", "sonic de frente", 24);
    sonic.animation.addByPrefix("sonicSIDES", "sonic derecha", 24);
    sonic.animation.addByPrefix("sonicUP", "sonic atras", 24);
    sonic.scale.set(0.30, 0.30);
    sonic.updateHitbox();
    sonic.antialiasing = true;

    player = new Player(638.68, 874);
    add(player);

    add(sonic);

    optionsSpr = new FlxSprite(23, 562);
    optionsSpr.frames = Paths.getSparrowAtlas("menuSprites/carteles", "exe");
    optionsSpr.animation.addByPrefix("static", "carteles");
    optionsSpr.animation.play("static");
    add(optionsSpr);
    add(mountains);
    add(hitbox);

    redRing = new FlxSprite(0, 60);
    redRing.frames = Paths.getSparrowAtlas("menuSprites/red_ring", "exe");
    redRing.animation.addByPrefix("idle", "Symbol 5");
    redRing.updateHitbox();
    redRing.scale.set(0.3, 0.3);
    redRing.animation.play("idle");
    redRing.screenCenter(X);
    redRing.immovable = true;
    redRing.antialiasing = true;
    add(redRing);

    FlxG.mouse.visible = true;

    FlxG.camera.follow(player, TOPDOWN, 1);

    var s = new FlxSprite(redRing.x, redRing.y).makeGraphic(120, 90, FlxColor.BLUE);
    s.updateHitbox();
    add(s);

    var o = new FlxSprite(23, 957).makeGraphic(120, 90, FlxColor.BLUE);
    o.updateHitbox();
    o.angle = 90;
    add(o);

    var e = new FlxSprite(1147, 957).makeGraphic(120, 90, FlxColor.BLUE);
    e.updateHitbox();
    e.angle = 90;
    add(e);

    var x = new FlxSprite(625, 1317).makeGraphic(120, 90, FlxColor.BLUE);
    x.updateHitbox();
    add(x);
    storyHBOX = s;

    ExitHBOX = x;

    extrasHBOX = e;

    settingsHBOX = o;

    setHitBoxInvisible([s, x, e, o]);

    // addHitBox(90, mountains.height, Std.int(mountains.width - 18), Std.int(mountains.height / 2));
    // addHitBox(90, mountains.height,  Std.int((mountains.width + 18)) * 2, Std.int(mountains.height / 2));

    // addHitBox(mountains.width, 90, Std.int(mountains.width / 2),  Std.int(mountains.height - 18));
    // addHitBox(mountains.width, 90, Std.int(mountains.width / 2),  Std.int((mountains.height + 18) * 2));
  }

  function addHitBox(wid:Int = 0, he:Int = 0, XE:Int, YE:Int = 0){
     var t = new FlxSprite(XE, YE).makeGraphic(wid, he, FlxColor.LIME);
     t.immovable = true;
     t.updateHitbox();
     add(t);

     FlxG.collide(player, t);
  }

  public function goToState(item:FlxSprite, ?toState:flixel.FlxState, ?exit:Bool = false){
    if (player.overlaps(item)){
      new FlxTimer().start(0.2, function(sus:FlxTimer)
      {
        if (!exit)
        FlxG.switchState(toState);
        else
        #if windows  Sys.exit(1); #end
      });
    }
  }

  function ff():Void{
    // nothing dumbass
  }

  public function setHitBoxInvisible(Hitboxes:Array<FlxSprite>) {
      for (shitBox in 0...Hitboxes.length){
         Hitboxes[shitBox].visible = false;
      }
  }

  var storyHBOX:FlxSprite;
  var settingsHBOX:FlxSprite;
  var extrasHBOX:FlxSprite;
  var ExitHBOX:FlxSprite;

  override function update(elapsed:Float) {

    if (FlxMath.inBounds(player.x, 0, FlxG.width)
			&& FlxMath.inBounds(player.y, 0, FlxG.height))
		{
			if (FlxMath.isDistanceToPointWithin(sonic, player.offset, 90))
			{
				sonic.velocity.set();
			}
			else
				FlxVelocity.moveTowardsObject(sonic, player, 250);
		}
		else
			sonic.velocity.set();

        super.update(elapsed);
  
    FlxG.collide(player, ExitHBOX);
    FlxG.collide(player, redRing);
    // FlxG.collide(player, hitbox);

    // if (FlxG.pixelPerfectOverlap(player, hitbox, 255)){
    //   FlxG.collide(player, hitbox);
    // }

    goToState(redRing, new StoryMenuState());

  
    goToState(ExitHBOX, true);

  if (player.overlaps(extrasHBOX)){
    new FlxTimer().start(0.2, function(sus:FlxTimer)
    {
    FlxG.switchState(new FreeplayState());
    });
  }
  if (player.overlaps(settingsHBOX)){
    new FlxTimer().start(0.2, function(sus:FlxTimer)
    {
      LoadingState.loadAndSwitchState(new options.OptionsState());
    });
  }

  if (sonic.overlaps(player)){
      sonic.animation.play("sonicLAUGH");
  }
  var right = FlxG.keys.anyPressed([RIGHT, D]);
  var left = FlxG.keys.anyPressed([LEFT, A]);
  var up = FlxG.keys.anyPressed([UP, W]);
  var down = FlxG.keys.anyPressed([DOWN, S]);
  var shifty = FlxG.keys.pressed.SHIFT;

  if (right || left){
      sonic.animation.play("sonicSIDES");
  }
  if (up){
    sonic.animation.play("sonicUP");
  }
  if (down){
    sonic.animation.play("sonicDOWN");
  }
  if (right){
     sonic.flipX = true;
  }
  if (left){
    sonic.flipX = true;
 }

	if (FlxG.mouse.overlaps(redRing) && FlxG.mouse.justPressed){
		add(new FlxText(0, 0, 0, "viva el porno", 32).screenCenter());
	}

    if (FlxG.keys.justPressed.SPACE){
      FlxG.switchState(new FreeplayState());
    }if (FlxG.keys.justPressed.Q){
      FlxG.switchState(new StoryMenuState());
    }if (FlxG.keys.justPressed.G){
      FlxG.switchState(new FreePlaySection());
    }if (FlxG.keys.justPressed.T){
      FlxG.switchState(new ShopState());
    }
  }
  override function  beatHit(){
    super.beatHit();

    if (curBeat % 2 == 0)
      player.dance();
  }
}

