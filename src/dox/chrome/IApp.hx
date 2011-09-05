package dox.chrome;

interface IApp {
	
	var docpath : String;
	var maxSuggestions : Int;
	
	var useHaxeOrgSearch : Bool;
	var useGoogleCodeSearch : Bool;
	var useGoogleDevelopmentSearch : Bool;
	var useStackoverflowSearch : Bool;
	
	//function loadAllAPIs() : Void;
	//function loadAPI( desc : TypeDescription ) : Void;
	
	#if DEBUG
	function log( v : Dynamic, ?inf : haxe.PosInfos ) : Void;
	#end
	
}
