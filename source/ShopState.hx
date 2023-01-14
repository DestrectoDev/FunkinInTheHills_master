package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.*;
import flixel.group.FlxSpriteGroup;
import flixel.util.*;
import flixel.text.*;
import openfl.filters.ShaderFilter;
import flixel.addons.text.FlxTypeText;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.utils.Assets;
import openfl.display.GraphicsShader;
#if sys
import sys.io.File;
import sys.FileSystem;
import flash.media.Sound;
#end

using StringTools;

typedef ItemData =
{
  public var directory:String;
  public var name:String;
  
  public var animName:String;
  public var desc:String;
  public var itemPrice:Int;
  
  public var songUnlocked:String;
  public var skinUnlocked:String;

  public var scale:Float;
  public var yRow:Int;
  public var xRow:Int;
}

class ShopState extends MusicBeatState{

    public static var ownedItems:Array<Bool> = [false, false, false, false, false, false];

    var items:FlxSprite;
   //json data
    public var directory:String = "exe";
    public var name:String = "head";
    
    public var animName:String = "ola bebe";
    public var desc:String = "shit dumbass";
    public var itemPrice:Int = 800;
    
    public var songUnlocked:String = "dark-rain";
    public var skinUnlocked:String = "";

    public var scale:Float = 1;
    public var yRow:Int = 0;
    public var xRow:Int = 0;
// 
    var moneyShit:Int = 0;

    var descBox:FlxSprite;
    var mesa:FlxSprite;
    var estantes:FlxSprite;
    var arcade:FlxSprite;
    var cartel:FlxSprite;
    var curChar:FlxSprite;
    var canTalk:Bool = false;

    var itemsGrp:FlxTypedGroup<FlxSprite>;

    var prefix:String = "shopAssets/";

    var itemsName:Array<String> = [];

    public static var curSelected:Int = 0;

    var moneyTxt:FlxText;
    var priceTxt:FlxText;

    var descItem:String = "hola";
    var descTxt:FlxText;

    var curCharacter:String = "tipica";

    var randomText:FlxTypeText;
    var shitText:FlxText;
    var randomMessage:String;

    var scaleMultX:Float = 0.0;
    var scaleMultY:Float = 0.0;
                                                                                    
    // curCharacter = "fiseroli"
    // curCharacter = "natu <falta asegurar>"
    var leShader = new shaders.VcrShader();

    override public function create(){
      bgColor = 0xFF666666;

      if (FlxG.save.data.ownedItems != null){
         ownedItems = FlxG.save.data.ownedItems;
      }
      
      var filtro = new ShaderFilter(leShader);

      FlxG.camera.setFilters([filtro]);

      FlxG.camera.filtersEnabled = ClientPrefs.shaders;


      arcade = new FlxSprite(903.4, 391.9, addImage("arcade"));
      add(arcade);

      curChar = new FlxSprite(31,257.85);

      // how to put your char.

      // first put the number case and your curCharacter , next put your path anda nimation and done!
      switch (FlxG.random.int(0, 6)){
        case 0:
        canTalk = false;
        curCharacter = "juane";
        curChar.frames = characterSpr("JUANA");
        curChar.animation.addByPrefix("idle", "juana", 24);
        curChar.x = -52;
        curChar.y = 131.85;
        curChar.scale.set(0.68, 0.68);
        case 1:
        canTalk = false;
        curCharacter = "yoyo";
        curChar.frames = characterSpr("afro");
        curChar.animation.addByPrefix("idle", "tipica", 24);
        case 2:
        canTalk = true;
        curCharacter = "skibanana";
        curChar.frames = characterSpr("skibanana");
        curChar.animation.addByIndices("idle", "Símbolo 1", [2, 3, 2, 3], "", 24, false);
        curChar.animation.addByPrefix("talk", "Símbolo 1", 24, false);
        curChar.x = -8;
        curChar.y = 480;
        case 3:
        canTalk = true;
        curCharacter = "draw";
        curChar.frames = characterSpr("pene");
        curChar.animation.addByPrefix("idle", "idle", 24);
        curChar.animation.addByPrefix("talk", "hablar", 24, false);
        curChar.scale.set(0.34, 0.34);
        curChar.x = -287;
        curChar.y = -0.150000000000034;
        case 4:
        canTalk = true;
        curCharacter = "assman";
        curChar.frames = characterSpr("assman");
        curChar.animation.addByPrefix("idle", "idle", 24);
        curChar.animation.addByPrefix("talk", "talking", 24, false);
        curChar.y = 145.85;
        curChar.x = -85;
        case 6:
        canTalk = false;
        curCharacter = "tipica";
        curChar.frames = characterSpr("tipica");
        curChar.animation.addByPrefix("idle", "tipica", 24); 
        case 5:
        canTalk = true;
        curCharacter = "torux";
        curChar.frames = characterSpr("Twompy_shop");
        curChar.animation.addByPrefix("idle", "Twompy_shop idle", 24);
        curChar.animation.addByPrefix("talk", "Twompy_shop talk", 24, false);
        curChar.x = -472;
        curChar.y = 114.85;
      }
      curChar.animation.play("idle");
      add(curChar);

      mesa = new FlxSprite(-27.85, 470.45);
      mesa.loadGraphic(addImage("mesa"));
      add(mesa);

      estantes = new FlxSprite(496.15, 300.5, addImage("estante"));
      add(estantes);

      descBox = new FlxSprite(329.8, 412.85);
      descBox.frames = Paths.getSparrowAtlas("shopAssets/descBox", "exe");
      descBox.animation.addByPrefix("static", "text bubble instancia", 24);
      descBox.animation.play("static");
      add(descBox);

      cartel = new FlxSprite(0,73.6, addImage("shop cartel"));
      add(cartel);

      itemsGrp = new FlxTypedGroup<FlxSprite>();
      add(itemsGrp);
      
      var directories:Array<String> = [Paths.getPreloadPath('items/')];

      // for (i in 0...directories.length) {
      //   var directory:String = directories[i];
      //   if(FileSystem.exists(directory)) {
      //     for (file in FileSystem.readDirectory(directory)) {
      //       var path = haxe.io.Path.join([directory, file]);
      //       if (!FileSystem.isDirectory(path) && file.endsWith('.json')) {
      //         var charToCheck:String = file.substr(0, file.length - 5);
      //         // if(!charToCheck.endsWith('-dead') && !tempMap.exists(charToCheck)) {
      //           // tempMap.set(charToCheck, true);
      //           itemsName.push(charToCheck);
      //         // }
      //       }
      //     }
      //   }
      // }

      itemsName = CoolUtil.coolTextFile(Paths.itemTxt('itemList'));

     for (i in 0...itemsName.length) {
      trace("YIPEEE IT WORKS :DDD");

      var itemPath:String = Paths.item(name);

      var path:String = itemPath;          

      var rawJson = Assets.getText(path);

      var json:ItemData = cast Json.parse(rawJson);

      if (!Assets.exists(path))
      {
        path = 'assets/items/tail.json'; // If a character couldn't be found, change him to gltichj just to prevent a crash
      }

      directory = json.directory;
      name = json.name;
      animName = json.animName;
      desc = json.desc;
      itemPrice = json.itemPrice;
      songUnlocked = json.songUnlocked;
      skinUnlocked = json.skinUnlocked;
      scale = json.scale;
      yRow = json.yRow;
      xRow = json.xRow;

      // if (!Assets.exists(json.eggPath))
      // 	frames = Paths.getSparrowAtlas("eggPath");
      // else
      // FUCK, I WAZ LAZY TO MAKE THIS CALL, FNFFFFFFFFFFF

        var animToPlay:String = animName;

        items = new FlxSprite(713.1,186.15);
        items.frames = Paths.getSparrowAtlas("items/" + json.directory);
        items.animation.addByPrefix(animName, animName, 24, true);
        items.animation.play(animToPlay);
        items.x = 170 + (125 * i);
        items.ID = i;
        itemsGrp.add(items);
    }

     moneyTxt = new FlxText(372, 641.6, FlxG.width, "coins: 2939389388383838", 32);
     moneyTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK, true);
     moneyTxt.borderSize = 1.23;
     add(moneyTxt);

     priceTxt = new FlxText(-272, 641.6, FlxG.width, "price: 2939389388383838", 32);
     priceTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK, true);
     priceTxt.borderSize = 1.23;
     add(priceTxt);

     descTxt = new FlxText(282, 560.6, FlxG.width, "desc: Hola", 32);
     descTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK, true);
     descTxt.borderSize = 1.23;
     add(descTxt);

     randomText = new FlxTypeText(0, 0, Std.int(FlxG.width * 0.6), "", 32);
     randomText.font = "VCR OSD Mono";
     randomText.color = FlxColor.BLACK;
     randomText.screenCenter();
     add(randomText);

     jeje();

     changeItem();
   
  }
   function jeje(){
     randomText.start(0.04, true);
     randomText.resetText(randomMessage);
   }
    public function addImage(path:String){
       return Paths.image("shopAssets/" + path, "exe");
    }

    public function characterSpr(path:String){
      return Paths.getSparrowAtlas("shopAssets/characters/" + path, "exe");
    }

    public function addPrefix(variable:FlxSprite, name:String, prefix:String, frames:Int = 24, ?flipX:Bool){
        variable.animation.addByPrefix(name, prefix, frames, flipX);
    }

    public function addSparrow(path:String){
       return Paths.getSparrowAtlas("shopAssets/" + path, "exe");
    }

    var priceShit:Float = 0;

    var result:Float = 0;
    override function update(elapsed:Float) {
        super.update(elapsed);

        randomMessage = "que, encerio?";
      //   switch (curCharacter){
      //     case "assman":
      //         if (FlxG.random.int(0, 1) == 1)
      //         randomMessage = "Hi, i'm assmanBruh, welcome to the shop\nchose any thing, not steal me pls";
      //         else
      //         randomMessage = "Oh, Welcome to the shop\n Chose Any stupid thing, i dont mind it";
      //     case "tipica":
      //         if (FlxG.random.int(0, 1) == 1)
      //         randomMessage = "fuck yeah 😏🍔";
      //         else
      //         randomMessage = "nashe ;)";
      //     case "draw":
      //         if (FlxG.random.int(0, 1) == 1)
      //         randomMessage = "Perro salchicha gordo bachicha";
      //     else
      //         randomMessage = "rayman mod god"; 
      //     case "yoyo":
      //       if (FlxG.random.int(0, 1) == 1)
      //         randomMessage = "Wenah (I don't know what that shit means)";
      //      else
      //         randomMessage = "I'm the 3D, buy some shit and I'll say the phrase >(BUENA SHIT)<"; 
      //      case "juane":
      //       if (FlxG.random.int(0, 2) == 1)
      //         randomMessage = "pensaba que era un pollo eeemmh ahora soy mujer";
      //       else if (FlxG.random.int(0, 2) == 2)
      //         randomMessage = "hola soy juane";
      //      else
      //         randomMessage = "wacatawacata"; 
      //     default:
      //       randomMessage = "hola beeb";
      //  }

        FlxG.watch.addQuick("charX: ",curChar.x);
        FlxG.watch.addQuick("charY: ",curChar.y);

        if (FlxG.mouse.overlaps(curChar)){
           if (FlxG.mouse.wheel != 0 && FlxG.keys.pressed.CONTROL){
              curChar.scale.set(FlxG.mouse.wheel * 1, FlxG.mouse.wheel * 1);
           }
        }

       if (curCharacter == "skibanana") {
          curChar.scale.set(scaleMultX, scaleMultY);
       }


       if (scaleMultX <= 1.4) {
        scaleMultX += elapsed * 0.9;
        scaleMultY += elapsed * 1;
       }
       if (scaleMultX >= 1.3){
        if ((elapsed * 500) % 2 == 0){
          trace("danced!");
       if (scaleMultX >= 0.9)
         scaleMultX -= elapsed * 0.9;
       if (scaleMultY >= 1)
         scaleMultY -= elapsed * 1;
        }
       }

        if (FlxG.keys.justPressed.T){
           jeje();
        }

        switch(curSelected) {
          default:
             descItem = desc;
            //  descItem = "Con esto podes jugar amaongas";
            //  descItem = "aca tomas cummie";
            //  descItem = "Com ña canezita puedes \nconvertir volverte invencible por 5 segundos\nno podras fallar";
            }

        descTxt.text = descItem;

        if (FlxG.keys.justPressed.R){
            FlxG.resetState();
        }


        result = ClientPrefs.ringCoins - priceShit;

        if (result <= 0)
        moneyTxt.color = FlxColor.RED;
        else
        moneyTxt.color = FlxColor.WHITE;
          
        moneyTxt.text = "coins: " + ClientPrefs.ringCoins + " < " + result;
        

        if (FlxG.keys.justPressed.SEVEN){
          ClientPrefs.ringCoins = 9999;
        }
        if (FlxG.keys.justPressed.TWO){
          ClientPrefs.ringCoins = 0;
      }
        if (controls.BACK){
           FlxG.switchState(new MainMenuState());
          //  FlxG.save.data.coinRings = PlayState.scoreEcuation;
        }
        if (controls.UI_LEFT_P)
            changeItem(-1);
        if (controls.UI_RIGHT_P)
            changeItem(1);
       /* 
        switch(itemsName[curSelected]){
            case "obj1":
              priceShit = 432;               
            case "obj2":
              priceShit = 122;
            case "obj3": 
              priceShit = 450;    
            case "obj4":
              priceShit = 999;
          }*/
          priceShit = itemPrice;

        priceTxt.text = "item price: " + priceShit;

        if (controls.ACCEPT){
          if (result >= 0){
              ClientPrefs.ringCoins -= Std.int(priceShit);
              ClientPrefs.saveRings();
              FlxG.save.data.ownedItems = ownedItems;
              FlxG.save.flush();
            }
        }
    }
    public function changeItem(item:Int = 0){
        curSelected += item;
        
        if (curSelected >= itemsName.length)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = itemsName.length-1;

        for (item in itemsGrp.members){
            item.color = FlxColor.WHITE;

            if (item.ID == curSelected){
                item.color = FlxColor.YELLOW;
            }
        }
    }

    override function beatHit(){
      super.beatHit();
     if (curBeat % 2 == 0) {
      if (canTalk && curChar != null){
        curChar.animation.play("talk");
        curChar.animation.finishCallback = function(name){ 
          curChar.animation.play("talk");
         curChar.animation.finishCallback = function(name){
          curChar.animation.play("idle");
         }
       }
      }
    }
    }
/*
    public function getItemFile(file:String) {
        var rawJson:String = null;
        var path:String = Paths.getItemJson(itemFile.directory, file);

        if(Assets.exists(path)) {
          rawJson = Assets.getText(path);
        }
        // #end
        else
        {
          return null;
        }
        return cast Json.parse(rawJson);
    }
    */
}