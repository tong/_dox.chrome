package dox.chrome;

using Lambda;
using StringTools;

class Options {
	
	static var app : dox.chrome.IApp;
	
	static function init() {
		
		app = chrome.Extension.getBackgroundPage().instance;
		
		#if DEBUG
		haxe.Log.trace = mytrace;
		trace( "DoX.options" );
		#end
		
		//var root : chrome.ui.options.manifest.Root = {
		var root = {
			name : "DoX",
			favicon : "img/icon_48.png",
			icon : "img/icon_48.png",
			search : true,
			helpUrl : "http://dox.disktree.net/", //TODO
			tabs : [
				{
					id : "settings",
					label : "Settings",
					groups : [
						{
							id : "api",
							label : "API description",
							content : [
								{ type : "description", content : "Current haXe API version used: "+app.apiVersion },
								{ id : "reload_api_description", type : "button", btn_label : "Reload" },
							]
						},
						{
							id : "haxe_targets",
							label : "API search settings",
							content : [
								{ id : "haxetarget_description", type : "description", content : "Toggle haXe targets to search." },
								//{ id : "haxetarget_cpp", type : "checkbox", label : "CPP" },
								{ id : "haxetarget_haxe", type : "checkbox", label : "haxe.*" },
								{ id : "haxetarget_flash", type : "checkbox", label : "flash.*" },
								{ id : "haxetarget_js", type : "checkbox", label : "js.*" },
								{ id : "haxetarget_neko", type : "checkbox", label : "neko.*" },
								{ id : "haxetarget_php", type : "checkbox", label : "php.*" }
								/*
								{ type : "margin", value : "16" },
								{ type : "description", content : "Toggle field/method search." },
								{ id : "search_inner", type : "checkbox", label : "Also search fields and methods" },
								*/
							]
						},
						{
							id : "search_suggestions",
							label : "Website search suggestions",
							content : [
								{ id : "websitesearch_description", type : "description", content : "Show search suggestions if your query is not found in the API." },
								{ id : "websitesearch_haxe_wiki", type : "checkbox", label : "HaXe wiki" },
								{ id : "websitesearch_haxe_ml", type : "checkbox", label : "HaXe mailing list" },
								{ id : "websitesearch_google_development", type : "checkbox", label : "Google development" },
								{ id : "websitesearch_google_code", type : "checkbox", label : "Google code" },
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
						/*
						{
							id : "pin",
							label : "Pin Tab",
							content : [
								{ type : "description", content : "Pin a tab as view" },
								{ id : "pin", type : "button", btn_label : "Pin Tab" }
							]
						}
						*/
					] 
				},
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
		};
		
		/*
		chrome.ui.Options.onTabChange = function(id:String) {
			//trace("TAB CHANGED:: "+id );
		}
		*/
		chrome.ui.Options.onGroupsChange = function(ids:Array<String>) {
			//trace("GROUPS CHANGED:: "+ids );
			for( id in ids ) {
				switch( id ) {
				case "haxe_targets" :
					for( id in app.haxeTargets ) {
						j( '#checkbox_haxetarget_'+id ).attr( 'checked', 'true' );
					}
				case "search_suggestions" :
					for( id in app.websiteSearchSuggestions ) {
						j( '#checkbox_websitesearch_'+id ).attr( 'checked', 'true' );
					}
				}
			}
		}
		chrome.ui.Options.onUserInteraction = function(id:String,?params:Dynamic){
			switch( id ) {
			case 'reload_api_description' :
				j( '#reload_api_description' ).hide();
				chrome.ui.Options.setBusy();
				haxe.Timer.delay( function(){
					app.updateAPI( function(err){
						if( err != null ) {
							showDesktopNotification( "DoX-ERROR!", "Failed to reload API description ("+err+")" );
						} else {
							showDesktopNotification( "DoX", "API description successfully reloaded", 3200 );
						}
						j( '#reload_api_description' ).show();
						chrome.ui.Options.setBusy( false );
					});
				}, 1 );
			case "reset" :
				LocalStorage.clear();
				j( '#reload_api_description' ).hide();
				j( '#reset' ).hide();
				haxe.Timer.delay( function(){
					app.updateAPI( function(err){
						j( '#reload_api_description' ).show();
						j( '#reset' ).show();
						//init();
						//TODO close the settings
						chrome.Tabs.getSelected( null, function(tab) {
							chrome.Tabs.remove(tab.id);
							app.initExtension();
							//chrome.Tabs.open(tab.id);
						});
					});
				}, 1 );
			case 'pin' :
				trace("PIN THE TAB");
				app.pinned = true;
				
			default :
				if( id.startsWith( 'checkbox_haxetarget' ) ) {
					var _id = id.substr( 20 );
					//trace(_id +":"+params );
					if( params ) {
						app.haxeTargets.push( _id );
					} else {
						app.haxeTargets.remove( _id );
					}
					Settings.save( app );
					if( app.haxeTargets.length == 0 ) {
						showDesktopNotification( "DoX-WARNING!", "You just deactivated all haXe targets, no suggestion for API search will be shown!", 5200 );
					}
				} else if( id.startsWith( 'checkbox_websitesearch' ) ) {
					var _id = id.substr( 23 );
					if( params ) {
						app.websiteSearchSuggestions.push( _id );
					} else {
						app.websiteSearchSuggestions.remove( _id );
					}
					Settings.save( app );
				}
			}
		}
		
		chrome.ui.Options.init( root );
	}
	
	static function showDesktopNotification( title : String, body : String, time : Int = -1 ) {
		var n = NotificationCenter.createNotification( "icons/icon_48.png", title, body );
		n.show();
		if( time > 0 )
			haxe.Timer.delay( n.cancel, time );
	}
	
	static inline function j( id : Dynamic ) : js.JQuery return new js.JQuery( id )

	#if DEBUG
	static inline function mytrace( v : Dynamic, ?inf : haxe.PosInfos ) { app.log( v, inf ); }
    #end
    
}
