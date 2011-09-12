package dox.chrome;

interface IApp {
	
	var docpath : String;
	var apiVersion(default,null) : String;
	var haxeTargets(default,null) : Array<String>;
	var websiteSearchSuggestions(default,null) : Array<String>;
	
	function initExtension() : Void;
	function updateAPI( ?cb : String->Void ) : Void;
	
	#if DEBUG
	function log( v : Dynamic, ?inf : haxe.PosInfos ) : Void;
	#end
	
}
