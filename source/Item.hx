package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Item extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var disptext:FlxText;
	public var songpath:String = "";

	public function new(text, x, y, songpath)
	{
		super();

		this.songpath = songpath;

		bg = new FlxSprite().makeGraphic(400, 40, FlxColor.WHITE);
		bg.screenCenter();
		bg.x -= x;
		bg.y -= y;
		bg.alpha = 0.6;

		disptext = new FlxText(bg.x + 10, bg.y + 8, 0, text, 18);
		disptext.setFormat("_sans", 20, FlxColor.BLACK, LEFT);

		add(bg);
		add(disptext);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.overlaps(this))
		{
			this.bg.color = FlxColor.GRAY;
		}
		if (!FlxG.mouse.overlaps(this))
		{
			this.bg.color = FlxColor.WHITE;
		}
	}
}
