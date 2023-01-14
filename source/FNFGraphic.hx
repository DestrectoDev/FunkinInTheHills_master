// similar to forever engine :V

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.*;

class FNFGraphic extends FlxSprite{

   public var animOffsets:Map<String, Array<Dynamic>>; 

   public var isPixelSprite:Bool = false;

   public var daPixelZoom:Float = 6;
   
   public function new(X, Y, ?graph:FlxGraphicAsset){
    super(X, Y, graph);

     if (graph != null)
       loadGraphic(graph);
          
      animOffsets = new Map<String, Array<Dynamic>>();

      if (isPixelSprite)
         setGraphicSize(Std.int(width * daPixelZoom));

   }
   /**
    for finish animation event
   **/
   public function onCompleteAnim(Anim:String, onComplete:Void->Void){
      playAnim(Anim);

    animation.finishCallback = function (name) {onComplete;}
    }
   /**
    For the SHIT FUCK WALL , jeje thanks
   **/
   public function createWall(color:flixel.util.FlxColor){
      makeGraphic(FlxG.width * 5, FlxG.height * 5, color);
   }
     
    /**
      FOR THE MENU POS SHIT

      put VERTICAL, to UP DOWN MENU
      put HORIZONTAL to RIGHT LEFT MENU PLIS, NOT TRYED PUT PORN
    **/
    public function isMenuItem(i, direction:String, object:FlxObject) {
        switch(direction){
          case "VERTICAL":
              object.y = 130 + (i * 230);
          case "HORIZONTAL":
              object.x = 130 + (i * 230);
        }
    }
    public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
        animation.play(AnimName, Force, Reversed, Frame);

        var daOffset = animOffsets.get(AnimName);
        if (animOffsets.exists(AnimName))
        {
            offset.set(daOffset[0], daOffset[1]);
        }
        else
            offset.set(0, 0);
	}

    override public function loadGraphic(Graphic:FlxGraphicAsset, Animated:Bool = false, Width:Int = 0, Height:Int = 0, Unique:Bool = false, ?Key:String):FlxSprite {
      return super.loadGraphic(Graphic, Animated, Width, Height, Unique, Key);
    }

   
    public function addOffset(name:String, Xs:Float, Ys:Float){
      animOffsets[name] = [Xs, Ys];
   }
   override public function destroy()
	{
		// dump cache stuffs
		if (graphic != null)
			graphic.dump();

		super.destroy();
	}
}