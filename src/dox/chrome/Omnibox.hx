package dox.chrome;

import haxe.rtti.CType;
import chrome.Omnibox;
using Lambda;
using StringTools;

class Omnibox {
	
	public static inline var MAX_SUGGESTIONS = 5;
	public static inline var HAXE_ORG_API_PATH = "http://haxe.org/api/";
	
	public var active(default,null) : Bool;
	public var searchPrivateTypes : Bool;
	public var showTypeKind : Bool;
	
	var app : IApp;
	var docpath : String;
	var search : APISearch;
	
	public function new( app : IApp ) {
		this.app = app;
		active = false;
		docpath = HAXE_ORG_API_PATH;
		//useLocalDocs = true;
		searchPrivateTypes = true;
		showTypeKind = true;
	}
	
	public function activate() {
		chrome.Omnibox.onInputStarted.addListener( onInputStarted );
		chrome.Omnibox.onInputCancelled.addListener( onInputCancelled );
		chrome.Omnibox.onInputChanged.addListener( onInputChanged );
		chrome.Omnibox.onInputEntered.addListener( onInputEntered );
		search = new APISearch( searchPrivateTypes );
		active = true;
		trace( "DoX omnibox activated" );
	}
	
	public function deactivate() {
		// TODO does not work (why?)
		chrome.Omnibox.onInputStarted.removeListener( onInputStarted );
		chrome.Omnibox.onInputCancelled.removeListener( onInputCancelled );
		chrome.Omnibox.onInputChanged.removeListener( onInputChanged );
		chrome.Omnibox.onInputEntered.removeListener( onInputEntered );
		search = null;
		active = false;
		trace( "DoX omnibox deactivated" );
	}
	
	function onInputStarted() {
		trace( "Input started" );
		setDefaultSuggestion( "<dim>- no input</dim>" );
	}
	
	function onInputCancelled() {
		trace( "Input cancelled" );
		setDefaultSuggestion( "<dim>- no input</dim>" );
	}
	
	function onInputChanged( text : String, suggest : Array<chrome.SuggestResult>->Void ) {
		
		if( text == null ) {
			setDefaultSuggestion( "<dim>- no input</dim>" );
			return;
		}
		var stext = text.trim();
		if( stext == null ) {
			setDefaultSuggestion( "<dim>- no input</dim>" );
			return;
		}
		if( stext == "" ) {
			setDefaultSuggestion( "<dim>- no input</dim>" );
			return;
		}
		
		var term = stext.toLowerCase();
		
		var numSuggestionsFound = 0; //suggestions.length
		
		//var stime = haxe.Timer.stamp();
		search.searchPrivateTypes = searchPrivateTypes;
		search.run( term, App.api.root, app.getHaxeTargets(), function(found){
			//trace( found.length+" trees found ("+(haxe.Timer.stamp()-stime)+")" );
			var suggestions = new Array<SuggestResult>();
			if( found.length > 0 ) { // add found links
				numSuggestionsFound = found.length;
				if( found.length > MAX_SUGGESTIONS ) found = found.slice( 0, MAX_SUGGESTIONS );
				var n = ( found.length < MAX_SUGGESTIONS ) ? found.length : MAX_SUGGESTIONS;
				for( i in 0...n ) {
					var tree = found[i];
					switch( tree ) {
					case TPackage(n,f,subs) :
						//if( n.fastCodeAt(0) == 95 ) // "_"
						//	continue;
						//trace( f );
						var parts = f.split( "." );
						for( p in parts ) {
							var url = docpath + parts.join("/");
							suggestions.push({
								content : docpath + f.split( "." ).join( "/" ).toLowerCase(),
								description : "<match>"+f+"</match> - <url><dim>"+url+"</dim></url>"
							});
						}
					case TTypedecl(t) : addTypeSuggestion( suggestions, t, "typedef" );
					case TEnumdecl(e) : addTypeSuggestion( suggestions, e, "enum" );
					case TClassdecl(c) : addTypeSuggestion( suggestions, c, "class" );
					//default : addTypeSuggestion( suggestions, TypeApi.typeInfos( tree ) );
					}
				}
			}
			if( stext.length >= 2 ) { // add website search suggestions
				var sugs = app.getWebsiteSearchSuggestions();
				if( suggestions.length < MAX_SUGGESTIONS && sugs.has( "google_group" ) )
					suggestions.push( createWebsiteSuggestionURL( stext, "Google Group", "https://groups.google.com/forum/#!searchin/haxelang/" ) );
				if( suggestions.length < MAX_SUGGESTIONS && sugs.has( "haxe_wiki" ) )
					suggestions.push( createWebsiteSuggestionURL( stext, "HaXe Wiki", "http://haxe.org/wiki/search?cse_query=" ) );
				if( suggestions.length < MAX_SUGGESTIONS && sugs.has( "haxe_ml" ) )
					suggestions.push( createWebsiteSuggestionURL( stext, "HaXe Mailing List", "http%3A%2F%2Fhaxe.1354130.n2.nabble.com%2Ftemplate%2FNamlServlet.jtp%3Fmacro%3Dsearch_page%26node%3D1354130%26query%3D" ) );
				if( suggestions.length < MAX_SUGGESTIONS && sugs.has( "stackoverflow" ) )
					suggestions.push( createWebsiteSuggestionURL( stext, "Stackoverflow", "http://stackoverflow.com/search?q=" ) );
				if( suggestions.length < MAX_SUGGESTIONS && sugs.has( "google_code" ) )
					suggestions.push( createWebsiteSuggestionURL( stext, "Google Code", "http://www.google.com/codesearch?q=" ) );
				if( suggestions.length < MAX_SUGGESTIONS && sugs.has( "google_development" ) )
					suggestions.push( createWebsiteSuggestionURL( stext, "Google Development", "http://www.google.com/cse?cx=005154715738920500810:fmizctlroiw&amp;q=" ) );
			}
			
			suggest( suggestions );
			setDefaultSuggestion( "<dim>- "+numSuggestionsFound+" found</dim>" );
			
		});
	}
	
	function createWebsiteSuggestionURL( t : String, id : String, url : String ) : SuggestResult {
		return { content : t+' ['+id+']', description : 'Search "<url>'+t+'</url>" at '+id+'<dim> - '+url+'"'+t.urlEncode()+'"</dim>' }
	}
	
	/*
	function filterTypePlatform( r : Array<TypeTree>, c : Dynamic, tree : TypeTree ) {
		if( c.platforms != null ) {
			var it : Iterable<String> = c.platforms;
			for( p in it ) {
				//trace(pfs);
				if( app.haxe_targets.has( p ) ) {
					r.push( tree );
					return;addTypeSuggestion
				}
			}
			trace("filtered");
		} else {
			r.push( tree );
		}
	}
	*/
	
	function addTypeSuggestion( suggestions : Array<SuggestResult>, c : TypeInfos, kind : String ) {
		var path : String = c.path.split( "." ).join( "/" ).toLowerCase();
		var i = c.path.lastIndexOf( "." );
		var name = ( i == -1 ) ? c.path : c.path.substr( i+1 );
		//if( path.startsWith( "flash" ) ) // hacking flash9 target path
			//path = "flash9"+path.substr(5);
		var url = docpath + path;
		var description = if( showTypeKind ) kind+" " else "";
		description +=  "<match>"+c.path+"</match>";
		//if( c.path != name ) description += " ("+c.path+")";
		if( c.doc != null && c.doc != "" ) {
			var s = c.doc.trim();
			if( s.length > 68 ) s = s.substr(0,64)+" ...";
			description += " - "+s;
		}
		description += "<url><dim> - "+url+"</dim></url>";
		suggestions.push( { content : url, description: description } );
	}
	
	function onInputEntered( text : String ) {
		trace( "Input entered: '"+text+"'" );
		if( text == null ) {
			//nav( docpath );
			return;
		}
		var stext = text.trim();
		if( stext.startsWith( "http://" ) || stext.startsWith( "https://" ) ) {
			App.nav( stext );
			return;
		}
		if( stext.startsWith( "www." ) || stext.endsWith( ".com" ) || stext.endsWith( ".net" ) || stext.endsWith( ".org" ) || stext.endsWith( ".edu" ) ) {
			App.nav( "http://"+stext );
			return;
		}
		
        var suffix = " [HaXe Wiki]";
        if( stext.endsWith( suffix ) ) {
        	App.nav( "http://haxe.org/wiki/search?s="+formatSearchSuggestionQuery( stext, suffix ) );
			return;
        }	
        if( stext.endsWith( suffix = " [Google Group]" ) ) {
			App.nav( "https://groups.google.com/forum/#!searchin/haxelang/"+formatSearchSuggestionQuery( stext, suffix ) );
			return;
		}
		if( stext.endsWith( suffix = " [HaXe Mailing List]" ) ) {
			App.nav( "http://haxe.1354130.n2.nabble.com/template/NamlServlet.jtp?macro=search_page&node=1354130&query="+formatSearchSuggestionQuery( stext, suffix )  );
			return;
		}
		if( stext.endsWith( suffix = " [Stackoverflow]" ) ) {
			App.nav( "http://stackoverflow.com/search?q="+StringTools.urlEncode( "haxe "+formatSearchSuggestionQuery( stext, suffix ) )+"&submit=search" );
			return;
		}
		if( stext.endsWith( suffix = " [Google Code]" ) ) {
			//nav( "http://www.google.com/codesearch?q="+StringTools.urlEncode( "haxe "+newquery + " lang:haxe" ) ); // does not work, google does not know lang:haxe
			App.nav( "http://www.google.com/codesearch?q="+StringTools.urlEncode( "haxe "+formatSearchSuggestionQuery( stext, suffix ) ) );
			return;
		}
		if( stext.endsWith( suffix = " [Google Development]" ) ) {
			App.nav( "http://www.google.com/cse?cx=005154715738920500810:fmizctlroiw&q=haxe "+formatSearchSuggestionQuery( stext, suffix ) );
			return;
		}
	}
	
	function setDefaultSuggestion( text : String = " " ) {
		var d = '<dim><match>HaXe</match></dim>';
		if( text != null ) d +=  " "+text;
		chrome.Omnibox.setDefaultSuggestion( { description : d } );
	}
	
	function formatSearchSuggestionQuery( t : String, suffix : String ) : String {
		return t.substr( 0, t.length - suffix.length ).trim().urlEncode();
	}
	
}
