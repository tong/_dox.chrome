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
	
//	var use_omnibox(default,setUseOmnibox) : Bool;
//	var haxe_targets(default,null) : Array<String>;
//	var website_search_suggestions(default,null) : Array<String>;
	
	/*
	*/
	//function getHaxeTargetsList() : Array<String>;
	//function getHaxeTargets() : Array<dox.HaXeTarget>;
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
