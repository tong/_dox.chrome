package dox.chrome;

interface IApp {
	
	/*
	var apiVersion(default,null) : String;
	var haxeTargets(default,null) : Array<String>;
	var printLocal(default,setPrintLocal) : Bool;
	var docpath : String;
	var websiteSearchSuggestions(default,null) : Array<String>;
	var pinned(default,setPinned) : Bool;
	
	function initExtension() : Void;
	function updateAPI( ?cb : String->Void ) : Void;
	#if DEBUG
	function log( v : Dynamic, ?inf : haxe.PosInfos ) : Void;
	#end
	*/
	
	///////////////////////////////////////////////////////////////////////////
	
	//var pinWebApp(default,set) : Bool;
	
	var use_omnibox(default,setUseOmnibox) : Bool;
	var haxe_targets(default,null) : Array<String>;
	var website_search_suggestions(default,null) : Array<String>;
	
	/*
	function getHaxeTargets() : Array<String>;
	function addHaxeTarget( t : String  ) : Void;
	function removeHaxeTarget( t : String  ) : Void;
	*/
	
	function resetSettings() : Void;
	function saveSettings() : Void;
	
	#if DEBUG
	function log( v : Dynamic, ?inf : haxe.PosInfos ) : Void;
	#end
	
}
