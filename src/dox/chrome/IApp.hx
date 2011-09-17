package dox.chrome;

interface IApp {
	
	/** */
	var apiVersion(default,null) : String;
	
	/** */
	var haxeTargets(default,null) : Array<String>;
	
	/** */
	var printLocal(default,setPrintLocal) : Bool;
	
	/** */
	var docpath : String;
	
	/** */
	var websiteSearchSuggestions(default,null) : Array<String>;
	
	/** */
	var pinned(default,setPinned) : Bool;
	
	/** */
	function initExtension() : Void;
	
	/** */
	function updateAPI( ?cb : String->Void ) : Void;
	
	#if DEBUG
	function log( v : Dynamic, ?inf : haxe.PosInfos ) : Void;
	#end
}
