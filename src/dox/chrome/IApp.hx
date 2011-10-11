package dox.chrome;

interface IApp {
	
	var searchPrivateTypes(getSearchPrivateTypes,setSearchPrivateTypes) : Bool;
	
	function getHaxeTargets() : Array<String>;
	function addHaxeTarget( t : String ) : Bool;
	function removeHaxeTarget( t : String ) : Bool;
	
	function getWebsiteSearchSuggestions() : Array<String>;
	function addWebsiteSearchSuggestion( t : String ) : Bool;
	function removeWebsiteSearchSuggestion( t : String ) : Bool;
	function clearWebsiteSearchSuggestions() : Void;
	
	//function saveSettings() : Void;
	function resetSettings() : Void;
	
	#if DEBUG
	function log( v : Dynamic, ?inf : haxe.PosInfos ) : Void;
	#end
	
}
