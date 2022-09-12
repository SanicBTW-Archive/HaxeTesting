package;

import js.Browser;

class AssetPaths
{
	public static var onlineData:Map<String, Dynamic> = new Map();

	// dumb ass shit, improve maybe??
	public static function fetch(url:String)
	{
		trace("Trying to fetch", url);
		var req = Browser.createXMLHttpRequest();
		req.addEventListener('load', function()
		{
			trace("Saving data");
			onlineData.set(url, req.response);
		});
		req.open("GET", url);
		req.send();
		return req.response;
	}
}
