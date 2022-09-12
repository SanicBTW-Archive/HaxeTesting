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

class PlayState extends FlxState
{
	var bg:FlxSprite;

	override public function create()
	{
		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.screenCenter();
		add(bg);

		BitmapData.loadFromFile("assets/images/Tatara.Kogasa.full.1894256.jpg").then(function(bit)
		{
			var newGraph = FlxGraphic.fromBitmapData(bit, false, "test");
			var the = new FlxSprite(0, 0).loadGraphic(newGraph);
			the.screenCenter();
			add(the);
			return Future.withValue(bit);
		});

		Sound.loadFromFile('assets/music/Fight_or_flight.mp3').then(function(sound)
		{
			var newSound = new FlxSound();
			newSound.loadEmbedded(sound, true, false);
			FlxG.sound.list.add(newSound);
			newSound.play();
			return Future.withValue(sound);
		});

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
