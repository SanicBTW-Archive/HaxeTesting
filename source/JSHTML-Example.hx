package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import haxe.Json;
import js.Browser;

// this is an example of browser.createxmlhttprequest(); function, also using js.html audio to play audio and shit
class PlayState extends FlxState
{
	var musicReq = Browser.createXMLHttpRequest();
	var htmlAudio = new js.html.Audio();
	var musicItems:FlxTypedGroup<Item> = new FlxTypedGroup<Item>();
	var bg:FlxSprite;
	var timeBar:FlxBar;

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

		add(musicItems);

		// Setup the XML Request
		musicReq.addEventListener("load", function(event)
		{
			var curItemPos = 360;
			// Add items based on the response
			var musicList:Dynamic = cast Json.parse(musicReq.responseText).items;
			for (i in 0...musicList.length)
			{
				musicItems.add(new Item(musicList[i].music_name, 410, curItemPos - 45,
					"http://sancopublic.ddns.net:5430/api/files/music/" + musicList[i].id + "/" + musicList[i].music_file));
				curItemPos -= 45;
			}
		});
		// Open it
		musicReq.open("GET", "http://sancopublic.ddns.net:5430/api/collections/music/records");
		// Send it
		musicReq.send();

		htmlAudio.addEventListener('durationchange', function()
		{
			timeBar.percent = 0;
		});

		htmlAudio.addEventListener('timeupdate', updateProgress);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		musicItems.forEach(function(item:Item)
		{
			if (FlxG.mouse.overlaps(item) && FlxG.mouse.justPressed)
			{
				htmlAudio.src = item.songpath;
				htmlAudio.load();
				htmlAudio.play();
			}
		});

		htmlAudio.volume = FlxG.sound.volume;

		super.update(elapsed);
	}

	function updateProgress()
	{
		var lengthMin:Dynamic = Math.floor(htmlAudio.duration / 60);
		if (lengthMin >= 10)
		{
			lengthMin = Math.floor(htmlAudio.duration / 60);
		}
		else
		{
			lengthMin = "0" + Math.floor(htmlAudio.duration / 60);
			if (lengthMin == "0NaN")
			{
				lengthMin = "00";
			}
			else
			{
				lengthMin = "0" + Math.floor(htmlAudio.duration / 60);
			}
		}

		var lengthSecs:Dynamic = Math.floor(htmlAudio.duration % 60);
		if (lengthSecs >= 10)
		{
			lengthSecs = Math.floor(htmlAudio.duration % 60);
		}
		else
		{
			lengthSecs = "0" + Math.floor(htmlAudio.duration % 60);
			if (lengthSecs == "0NaN")
			{
				lengthSecs = "00";
			}
			else
			{
				lengthSecs = "0" + Math.floor(htmlAudio.duration % 60);
			}
		}

		var songPercent = (htmlAudio.currentTime / htmlAudio.duration);
		var curMin:Dynamic = Math.floor(htmlAudio.currentTime / 60) >= 10 ? Math.floor(htmlAudio.currentTime / 60) : "0"
			+ Math.floor(htmlAudio.currentTime / 60);
		var curSecs:Dynamic = Math.floor(htmlAudio.currentTime % 60) >= 10 ? Math.floor(htmlAudio.currentTime % 60) : "0"
			+ Math.floor(htmlAudio.currentTime % 60);

		FlxG.watch.addQuick("Song length ", lengthMin + ":" + lengthSecs);
		FlxG.watch.addQuick("Song time ", curMin + ":" + curSecs + " (" + songPercent * 100 + ")");

		timeBar.percent = songPercent * 100;
	}

	function log(log:Dynamic)
	{
		FlxG.log.add(log);
		trace(log);
	}
}
