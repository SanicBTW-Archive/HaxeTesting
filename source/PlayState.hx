package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import haxe.Json;
import js.Browser;
import lime.app.Future;
import openfl.media.Sound;

// a mix between JSHTML Example and FutureUsage Example
class PlayState extends FlxState
{
	var musicReq = Browser.createXMLHttpRequest();
	var musicItems:FlxTypedGroup<Item> = new FlxTypedGroup<Item>();
	var bg:FlxSprite;
	var timeBar:FlxBar;
	var music:FlxSound;

	override public function create()
	{
		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE);
		bg.screenCenter();
		add(bg);

		// shittiest way
		timeBar = new FlxBar();
		timeBar.screenCenter();
		timeBar.y = FlxG.height * 0.97;
		timeBar.screenCenter(X);
		timeBar.scale.set(10, 1);
		add(timeBar);

		music = new FlxSound();
		FlxG.sound.list.add(music);

		add(musicItems);

		musicReq.addEventListener("load", function(event)
		{
			var curItemPos = 360;
			var musicList:Dynamic = cast Json.parse(musicReq.responseText).items;
			for (i in 0...musicList.length)
			{
				musicItems.add(new Item(musicList[i].music_name, 410, curItemPos - 45,
					"http://sancopublic.ddns.net:5430/api/files/music/" + musicList[i].id + "/" + musicList[i].music_file));
				curItemPos -= 45;
			}
		});
		musicReq.open("GET", "http://sancopublic.ddns.net:5430/api/collections/music/records");
		musicReq.send();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		musicItems.forEach(function(item:Item)
		{
			if (FlxG.mouse.overlaps(item) && FlxG.mouse.justPressed)
			{
				Sound.loadFromFile(item.songpath).then(function(sound)
				{
					music.loadEmbedded(sound, true, false);
					music.play();
					return Future.withValue(sound);
				});
			}
		});

		timeBar.percent = (music.time / music.length) * 100;

		super.update(elapsed);
	}
}
