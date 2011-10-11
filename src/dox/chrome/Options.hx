package dox.chrome;

using Lambda;
using StringTools;

class Options {

	static var app : dox.chrome.IApp;
	
	static function init() {
	
		app = chrome.Extension.getBackgroundPage().instance;
		
		#if DEBUG
		haxe.Log.trace = mytrace;
		//haxe.Firebug.redirectTraces();
		trace( "DoX.options" );
		#end
		
		chrome.ui.Options.onGroupsChange = function(ids:Array<String>) {
			for( id in ids ) {
				switch( id ) {
				case "haxe_targets" :
					//trace(app.haxe_target);
					for( id in app.getHaxeTargets() )
						j( '#haxetarget_'+id ).attr( 'checked', 'true' );
				case "search_suggestions" :
					for( id in app.getWebsiteSearchSuggestions() )
						j( '#websitesearch_'+id ).attr( 'checked', 'true' );
				}
			}
		}
		chrome.ui.Options.onUserInteraction = function(id:String,?params:Dynamic) {
			switch( id ) {
			case "reset" :
				j( '#reload_api_description' ).hide();
				j( '#reset' ).hide();
				haxe.Timer.delay( function(){
					app.resetSettings();
					haxe.Timer.delay( function(){
						chrome.Tabs.getSelected( null, function(tab) {
							j('#chrome-options').fadeOut(400,function(){
								chrome.Tabs.remove(tab.id);
							});
						});
					}, 200 );
				}, 1 );
			case "omnibox" :
				//trace("TODO toggle omnibox");
				//app.omnibox != app.omnibox;
			default :
				if( id.startsWith( 'haxetarget' ) ) {
					var _id = id.substr( 11 );
					if( params ) app.addHaxeTarget( _id ) else app.removeHaxeTarget( _id );
			//		app.saveSettings();
					if( app.getHaxeTargets().length == 0 )
						showDesktopNotification( "Warning!", "You just deactivated all haXe targets!", 5200 );
					return;
				}
				if( id.startsWith( 'websitesearch' ) ) {
					var _id = id.substr( 14 );
					if( params ) app.addWebsiteSearchSuggestion( _id ) else app.removeWebsiteSearchSuggestion( _id );
			//		app.saveSettings();
					return;
				}
				if( id.startsWith( 'displaytarget_' ) ) {
					var _id = id.substr( 14 );
					//TODO ........................
					var info = j( '#displaytarget_description' );
					switch( _id ) {
					case "webapp" :
						info.html('Web app display');
					case "omnibox" :
						info.html('Omnibox display');
					}
					//trace(_id);
					return;
				}
				trace("??????? "+id );
			}
		}
		
		/////////////////////////////////////////////////////////
		
		var root = cast {
			name : "DoX",
			favicon : "img/favicon.png",
			icon : "img/icon_48.png",
			search : true,
			help_url : "http://dox.disktree.net/help",
			tabs : [
				{
					id : "settings",
					label : "Search",
					groups : [
						/*
						{
							id : "displaytarget",
							label : "Display",
							content : [
								{ id : "displaytarget", type : "radio", options : [
									{ id : "displaytarget_omnibox", title : "Omnibox display" },
									{ id : "displaytarget_webapp", title : "Web display" },
								] },
								{ id : "displaytarget_description", type : "description", content : "ABC" },
							]
						},
						*/
						{
							id : "haxe_targets",
							label : "Search settings",
							content : [
								{ id : "haxetarget_description", type : "description", content : "Toggle haXe targets to search." },
								{ id : "haxetarget_cpp", type : "checkbox", label : "cpp" },
								{ id : "haxetarget_flash", type : "checkbox", label : "flash" },
								{ id : "haxetarget_js", type : "checkbox", label : "js" },
								{ id : "haxetarget_neko", type : "checkbox", label : "neko" },
								{ id : "haxetarget_php", type : "checkbox", label : "php" },
								//{ id : "haxetarget_sys", type : "checkbox", label : "sys" },
								/*
								{ type : "margin", value : "16" },
								{ type : "description", content : "Toggle field/method search." },
								{ id : "search_inner", type : "checkbox", label : "Also search fields and methods" },
								*/
							]
						},
						/*
						{
							id : "docpath",
							label : "Documentation provider",
							content : [
								{ id : "haxetarget_description", type : "description", content : "Toggle haXe targets to search." },
								//{ id : "haxetarget_cpp", type : "checkbox", label : "CPP" },
								{ id : "haxetarget_flash", type : "checkbox", label : "flash" },
								{ id : "haxetarget_js", type : "checkbox", label : "js" },
								{ id : "haxetarget_neko", type : "checkbox", label : "neko" },
								{ id : "haxetarget_php", type : "checkbox", label : "php" }
							]
						},
						*/
						/*
						{
							id : "packages",
							label : "Active packages",
							//content : getActivePackages()
							content :[
								{ id : "package_description", type : "description", content : "Toggle haXe targets to search." },
								{ id : "haxetarget_flash", type : "checkbox", label : "flash" },
								{ id : "haxetarget_js", type : "checkbox", label : "js" },
								{ id : "haxetarget_neko", type : "checkbox", label : "neko" },
								{ id : "haxetarget_php", type : "checkbox", label : "php" }
							]
						},
						*/
						{
							id : "search_suggestions",
							label : "Website search suggestions",
							content : [
								{ id : "websitesearch_description", type : "description", content : "Show search suggestions if your query is not found in the API." },
								{ id : "websitesearch_haxe_wiki", type : "checkbox", label : "HaXe Wiki" },
								{ id : "websitesearch_haxe_ml", type : "checkbox", label : "HaXe Mailing List" },
								{ id : "websitesearch_google_development", type : "checkbox", label : "Google Development" },
								{ id : "websitesearch_google_code", type : "checkbox", label : "Google Code" },
								{ id : "websitesearch_stackoverflow", type : "checkbox", label : "Stackoverflow" }
							]
						},
						{
							id : "reset",
							label : "Reset",
							content : [
								{ type : "description", content : "Reset to default settings." },
								{ id : "reset", type : "button", btn_label : "Reset" }
							]
						}
					] 
				},
				/*
				{
					id : "webapp",
					label : "Webapp",
					groups : [
						{
							id : "info",
							content : [
								{ id : "author", type : "description", content : "<p>Download/Install latest version of DoX from the <a href='https://chrome.google.com/webstore/detail/oocmdgebgfalcjefajhpkdkmlfcanljg' target='_blank'>chrome web store</a>.</p>" }
							]
						}
					]
				},
				*/
				{
					id : "about",
					label : "About",
					groups : [
						{
							id : "info",
						//	label : "DOX Info",
							content : [
								{ id : "any", type : "description", content : "This extension integrates with the Chrome omnibox to bring <a href='http://haxe.org' title='http://haxe.org'>haXe</a> standard library API autocompletion right to your fingertips.
	To use, type <b>hx</b>, followed by a space or tab, followed by your query. The first time you use the extension, there may be some delay, as the API description is retrieved remotely and cached locally. On subsequent uses, however, you should see instantaneous autocompletions. Selecting a completion or fully typing a class, enum or typedef name and then pressing enter will take you directly to the relevant documentation.
	If a completion cannot be found, several search suggestions will be provided, including Google Codesearch, Stackoverflow and others." }
							]
						},
						{
							id : "install",
							content : [
								{ id : "author", type : "description", content : "<p>Download/Install latest version of DoX from the <a href='https://chrome.google.com/webstore/detail/oocmdgebgfalcjefajhpkdkmlfcanljg' target='_blank'>chrome web store</a>.</p>" }
							]
						},
						{
							id : "source",
							label : "Source code",
							content : [
								{ id : "source", type : "description", content : "<p>DoX is open source, written in <a href='http://haxe.org' title='http://haxe.org' target='_blank'>haXe</a> and licensed under <a href='http://www.gnu.org/licenses/gpl-3.0.txt' title='http://www.gnu.org/licenses/gpl-3.0.txt' target='_blank'>GPL 3.0</a>.<br>
	You can pull/fork the source code from <a href='https://github.com/tong/dox.chrome' title='https://github.com/tong/dox.chrome' target='_blank'>github</a>.</p>" }
							]
						},
						{
							id : "author",
							content : [
								{ id : "author", type : "description", content : "<p>DoX is created by <a href='http://disktree.net' title='http://disktree.net' target='_blank'>disktree.net</a>.</p>" }
							]
						}
					]
				}
			]
		}
		chrome.ui.Options.init( root );
	}
	
	/*
	public static function getActivePackages() : Array<Dynamic> {
		return null;	
	}
	*/
	
	static function showDesktopNotification( title : String, m : String, time : Int ) {
		dui.Notification.show( "DoX - "+title, m, time, "icons/icon_48.png");
	}
	
	static inline function j( id : Dynamic ) : js.JQuery return new js.JQuery( id )
	
	#if DEBUG
	static inline function mytrace( v : Dynamic, ?inf : haxe.PosInfos ) app.log( v, inf )
    #end
    
}
