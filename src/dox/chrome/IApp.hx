package dox.chrome;

interface IApp {
	
	var docpath : String;
	var maxSuggestions : Int;
	
	var useHaxeOrgSearch : Bool;
	var useGoogleCodeSearch : Bool;
	var useGoogleDevelopmentSearch : Bool;
	var useStackoverflowSearch : Bool;
	
	function updateAPI( ?cb : String->Void ) : Void;
	
	#if DEBUG
	function log( v : Dynamic, ?inf : haxe.PosInfos ) : Void;
	#end
	
}
