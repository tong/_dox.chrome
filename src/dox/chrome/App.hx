package dox.chrome;

class App implements IApp {
		 // implements IExt {
	
	public static var api(default,null) : API;
	
	//static var settings : Settings;
	static var omnibox : Omnibox;
	static var webapp : WebApp;
	static var online : Bool;
	
	public var use_omnibox(default,setUseOmnibox) : Bool;
	public var haxe_targets(default,null) : Array<String>;
	public var website_search_suggestions(default,null) : Array<String>;
	
	//var haxe_targets : Array<String>;
	
	function new() {
	}
	
	function setUseOmnibox( v : Bool ) : Bool {
		if( v ) {
			if( omnibox == null ) omnibox = new Omnibox( this );
			omnibox.activate();
		} else {
			if( omnibox != null ) omnibox.deactivate();
		}
		return use_omnibox = v;
	}
	
	function init() {
		
		online =  untyped window.navigator.onLine;
		
		var d = LocalStorage.getItem( "settings" );
		if( d == null ) {
			resetSettings();
		} else {
			var d = JSON.parse( d );
			use_omnibox = d.use_omnibox;
			haxe_targets = d.haxe_targets;
			website_search_suggestions = d.website_search_suggestions;
		}
		
		api = new API();
		//api.activePlatforms = haxe_targets;
		api.init( function(err){
			trace("API INITIALIZED");
			trace( api.root.length );
			if( api.root.length == 0 ) {
				var t = haxe.Http.requestUrl( "http://192.168.0.110/hxmpp/doc/api_flash.xml" );
				App.api.loadString( t, ["flash"], function(e) {
					
				});
				/*
				App.api.loadRemote( "std", "http://192.168.0.110/dox.c/api_std.xml", "php", function(e){
					//mainmenu.classindex.update();
					//view.set( StateMain );
				});
				*/
			}
		});
		
		if( use_omnibox ) {
			omnibox = new Omnibox( this );
			omnibox.activate();
		}
		
		/*
		webapp = new WebApp();
		webapp.init();
		*/
		
		/* 
		var github = new dox.Github();
		github.loadRepoInfo( "hxmpp" );
		*/
	}
	
	/// ---------- IApp ----------
	
	/*
	public function getWebsiteSearchSuggestions() : Array<String> {
	}
	
	public function addWebsiteSearchSuggestion( t : String ) {
	}
	
	public function removedWebsiteSearchSuggestion( t : String ) {
	}
	
	public function cleardWebsiteSearchSuggestions() {
	}
	*/
	
	/* 
	public function getHaxeTargets() : Array<String> {
		return haxe_targets.copy();
	}
	
	public function addHaxeTarget( t : String ) {
		haxe_targets.push( t );
		//api.activePlatforms.push(t);
	}
	
	public function removeHaxeTarget( t : String ) {
		haxe_targets.remove( t );
		//api.activePlatforms.remove(t);
	}
	*/
	
	public function resetSettings() {
		trace( "Reset settings" );
		use_omnibox = true;
		haxe_targets = ["flash","js","neko","php"];
		website_search_suggestions = ["haxe_wiki","haxe_ml","google_code","google_development","stackoverflow"];
		saveSettings();
	}
	
	public function saveSettings() {
		//var d : Settings = this;
		LocalStorage.setItem( "settings", JSON.stringify( {
			use_omnibox : use_omnibox ,
			//packages : packages = ["haxe","flash","js","neko","php"],
			website_search_suggestions : website_search_suggestions,
			haxe_targets : haxe_targets
		} ) );
	}
	
	#if DEBUG
	public function log( v : Dynamic, ?inf : haxe.PosInfos ) haxe.Log.trace( v, inf )
	#end
	
	/// ---------- IExt ----------
	//..
	
	
	//--------------------------------------
	
	public static function nav( url : String ) {
		chrome.Tabs.getSelected( null, function(tab) { chrome.Tabs.update( tab.id, { url : url } ); } );
	}
	
	static function __init() : IApp {
		#if DEBUG
		if( haxe.Firebug.detect() ) haxe.Firebug.redirectTraces();	
		trace( "DoX.chrome" );
		#end
		var app : IApp = new App();
		return app;
	}
	
}
