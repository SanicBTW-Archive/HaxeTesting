package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import haxe.Json;
import js.Browser;
import lime.app.Future;
import lime.graphics.Image;
import openfl.display.BitmapData;
import openfl.media.Sound;

// this is an example of futures, apparently the haxe response to promises or asynchronous stuff, uses bitmapdata and sound
// bad documented or maybe not, what really counts is that is explained somehow
class PlayState extends FlxState
{
	var bg:FlxSprite;

	override public function create()
	{
		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.screenCenter();
		add(bg);

		// it was the only image i had atm alright? :(

		// jokes aside, calling loadFromFile in bitmapdata will create a new Future<BitmapData> this cannot be used
		// on graphics or sprites, for now, make a then callback and pass an argument like below on .then(function(arg - this is actually the BitmapData name))
		// once done that use the BitmapData name to create a new FlxGraphic using fromBitmapData and passing the BitmapData name in the first argument
		BitmapData.loadFromFile("assets/images/Tatara.Kogasa.full.1894256.jpg").then(function(bit)
		{
			// Create a new FlxGraphic from BitmapData using "bit" (BitmapData name declared above on then callback)
			var newGraph = FlxGraphic.fromBitmapData(bit, false, "test");
			// Create a new FlxSprite from loadGraphic using the FlxGraphic created above
			var the = new FlxSprite(0, 0).loadGraphic(newGraph);
			the.screenCenter();
			// Add the new FlxSprite
			add(the);
			// The return is required, no matter what value to return but you must do "return Future.withValue()"
			return Future.withValue(bit);
		});

		// Returns a new Future<Sound> which obviously cannot be used for sounds yet
		// Create a then callback that contains a function and an argument that will be the loaded Sound (not Future<Sound>)
		Sound.loadFromFile('assets/music/Fight_or_flight.mp3').then(function(sound)
		{
			// Create a new FlxSound instance
			var newSound = new FlxSound();
			// Load an embedded sound, use the argument passed on the function (in this case "sound") to set it in the new instance
			newSound.loadEmbedded(sound, true, false);
			// Add the new instance to the Flixel Sound List to make it compatible with the Flixel Sound Handler
			FlxG.sound.list.add(newSound);
			// Play the new instance
			newSound.play();
			// Must return something no matter what but you must return it, "return Future.withValue()"
			return Future.withValue(sound);
		});

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
