import flixel.*;
class Player extends FlxSprite{  
  public var SPEED:Int = 500;
  public var GRAVITY:Int = 600;
  public var sonic:FlxSprite;

  public function new (X, Y)  {
    super(X, Y);

    drag.x = SPEED *5;
    drag.y = SPEED *5;
	
    // var tex = Paths.getSparrowAtlas("menuSprites/map_boi", "exe");
    frames = Paths.getSparrowAtlas("menuSprites/map_boi", "exe");
    animation.addByPrefix("idle", "sprite idle alante", 24);
    animation.addByPrefix("idle lados", "sprite idle lado", 24);
    animation.addByPrefix("idle up", "sprite idle atras", 24);
    animation.addByPrefix("bola", "sprite roda", 24);
    animation.addByPrefix('walk', "sprite run lado", 24, false);
    animation.addByPrefix("down", "sprite run alante", 24);
    animation.addByPrefix("up", "sprite run atras", 24);
	  scale.set(0.30, 0.30);
    updateHitbox();
  }

  public function move ()
  {
    var right = FlxG.keys.anyPressed([RIGHT, D]);
    var left = FlxG.keys.anyPressed([LEFT, A]);
    var up = FlxG.keys.anyPressed([UP, W]);
    var down = FlxG.keys.anyPressed([DOWN, S]);
    var shifty = FlxG.keys.pressed.SHIFT;

   
    if (right || left){
      animation.play('walk');
    }
    else if (up){
      animation.play("up");
    }
    else if (down){
      animation.play("down");
    }
    else {
    dance();
    }
    {
      setFacingFlip(FlxObject.LEFT, false, false);
      setFacingFlip(FlxObject.RIGHT, true, false);
    }
    
    // var nextPointX:Int = Std.int(Math.floor(x + 8 + Math.sin(angle * (Math.PI / 180))*width)/width);
		// var nextPointY:Int = Std.int(Math.floor(y + 8 + Math.cos(angle * (Math.PI / 180))*height)/height);

    if (right && left){
		velocity.x = 0;
	}else if (right){
    // MainMenuState.mountainCollSpr.setPosition(nextPointX*width,nextPointY*height);
		// if (nextPointX >= MainMenuState.collisionMap.length
		//  || nextPointY >= MainMenuState.collisionMap[nextPointX].length
    //      || MainMenuState.collisionMap[nextPointX][nextPointY])
        velocity.x = SPEED;

        facing = FlxObject.RIGHT;
    }else if (left){
      // MainMenuState.mountainCollSpr.setPosition(nextPointX*width,nextPointY*height);
      // if (nextPointX >= MainMenuState.collisionMap.length
      //  || nextPointY >= MainMenuState.collisionMap[nextPointX].length
      //      || MainMenuState.collisionMap[nextPointX][nextPointY])
        velocity.x = -SPEED;
        
        facing = FlxObject.LEFT;
    }else if (up){
      // MainMenuState.mountainCollSpr.setPosition(nextPointX*width,nextPointY*height);
      // if (nextPointX >= MainMenuState.collisionMap.length
      //  || nextPointY >= MainMenuState.collisionMap[nextPointX].length
      //      || MainMenuState.collisionMap[nextPointX][nextPointY])
        velocity.y = -SPEED;
    }else if (down){
      // MainMenuState.mountainCollSpr.setPosition(nextPointX*width,nextPointY*height);
      // if (nextPointX >= MainMenuState.collisionMap.length
      //  || nextPointY >= MainMenuState.collisionMap[nextPointX].length
      //      || MainMenuState.collisionMap[nextPointX][nextPointY])
        velocity.y = SPEED;
    }
    if (shifty){
      animation.play("bola");
      SPEED = 860;
    }else{
        SPEED = 500;
    }

  }
  var danced:Bool = false;
  public function dance(){
    trace("!dance");

    danced = !danced;
    
    if (danced)
    animation.play("idle");
    else
    animation.play("idle");
  }

  override function update(elapsed:Float) {
    super.update(elapsed);
    move();
  }
 } 