package dox.chrome;

import haxe.rtti.CType;
import chrome.Omnibox;
using Lambda;
using StringTools;

class Omnibox {
	
	public static inline var MAX_SUGGESTIONS = 10;
	
	public var active(default,null) : Bool;
	
	var app : IApp;
	var docpath : String;
	
	public function new( app : IApp ) {
		this.app = app;
		active = false;
		docpath = "http://haxe.org/api/";
	}
	
	public function activate() {
		chrome.Omnibox.onInputStarted.addListener( onInputStarted );
		chrome.Omnibox.onInputCancelled.addListener( onInputCancelled );
		chrome.Omnibox.onInputChanged.addListener( onInputChanged );
		chrome.Omnibox.onInputEntered.addListener( onInputEntered );
		active = true;
	}
	
	public function deactivate() {
		// TODO does not work (why?)
		chrome.Omnibox.onInputStarted.removeListener( onInputStarted );
		chrome.Omnibox.onInputCancelled.removeListener( onInputCancelled );
		chrome.Omnibox.onInputChanged.removeListener( onInputChanged );
		chrome.Omnibox.onInputEntered.removeListener( onInputEntered );
		active = false;
	}
	
	function onInputStarted() {
		trace( "Input started" );
	}
	
	function onInputCancelled() {
		trace( "Input cancelled" );
		setDefaultSuggestion();
	}
	
	function onInputChanged( text : String, suggest : Array<chrome.SuggestResult>->Void ) {
		if( text == null )
			return;
		var stext = text.trim();
		if( stext == null )
			return;
		if( stext == "" ) {
			setDefaultSuggestion();
			return;
		}
		var term = stext.toLowerCase();
		var suggestions = new Array<SuggestResult>();
		var found = App.api.search( term );
		//trace( found.length );
		
		//TODO filter haxe targets
		trace(found.length);
		
		//var r = new Array<SuggestResult>();
		//var r = filterPlatform( found ); //new Array<SuggestResult>();
		
		/*
		for( f in found ) {
			//trace( f);
			switch(f) {
			case TPackage(n,f,subs) :
			case TTypedecl(t) :
			case TEnumdecl(e) : 
			case TClassdecl(c) :
				//trace( c.platforms );
				if( c.platforms != null ) {
					for( p in c.platforms ) {
						var match = false;
						for( t in app.haxe_targets ) {
							if( t == p ) {
								match = true;
								break;
							}
						}
						if( match ) break;
					}
					//if( !match ) return;
				}
			}
		}
		*/

		// TODO sort by name
		
		
		var suggestions = new Array<SuggestResult>();
		if( found.length > 0 ) {
			if( found.length > MAX_SUGGESTIONS ) found = found.slice( 0, MAX_SUGGESTIONS );
			for( i in 0...MAX_SUGGESTIONS ) {
				if( i > found.length-1 )
					break;
				var tree = found[i];
				switch( tree ) {
				case TPackage(n,f,subs) :
	//				if( n.fastCodeAt(0) == 95 ) // "_"
	//					continue;
					//trace( f );
					var parts = f.split( "." );
					for( p in parts ) {
						if( p == term ) {
							var url = docpath + parts.join("/");
							suggestions.push({
								content : docpath + f.split( "." ).join( "/" ).toLowerCase(),
								description : "<match>"+f+"</match> - <url>"+url+"</url>"
							});
						}
					}
				case TTypedecl(t) : addSuggestion( suggestions, t );
				case TEnumdecl(e) : addSuggestion( suggestions, e );
				case TClassdecl(c) : addSuggestion( suggestions, c );
				}
			}
		}
		
		if( stext.length >= 2 ) {
			//trace( suggestions.length +" : "+ MAX_SUGGESTIONS+" "+app.website_search_suggestions+": "+app.website_search_suggestions.has( "haxe_wiki" ) );
			if( suggestions.length < MAX_SUGGESTIONS && app.website_search_suggestions.has( "haxe_wiki" ) ) {
				suggestions.push( {
					 content : stext+" [HaXe Wiki]",
					 description : [ "Search \"<match>", stext, "</match>\" at <match><url>HaXe-Wiki</url></match> - <url>http://haxe.org/wiki/search?s=", StringTools.urlEncode(stext), "</url>" ].join('')
				});
				if( suggestions.length < MAX_SUGGESTIONS && app.website_search_suggestions.has( "haxe_ml" ) ) {
					suggestions.push( {
				 		content : stext+" [HaXe Mailing List]",
				 		description : [ "Search \"<match>", stext, "</match>\" at <match><url>HaXe-MailingList</url></match> - <url>http%3A%2F%2Fhaxe.1354130.n2.nabble.com%2Ftemplate%2FNamlServlet.jtp%3Fmacro%3Dsearch_page%26node%3D1354130%26query%3D", StringTools.urlEncode(stext), "</url>" ].join('')
				 	});
				}
				if( suggestions.length < MAX_SUGGESTIONS && app.website_search_suggestions.has( "stackoverflow" ) ) {
					suggestions.push( {
				 		content : stext+" [Stackoverflow]",
				 		description : [ "Search \"<match>", stext, "</match>\" at <match><url>Stackoverflow</url></match> - <url>http://stackoverflow.com/search?q=", StringTools.urlEncode(stext), "</url>" ].join('')
				 	});
				}
				if( suggestions.length < MAX_SUGGESTIONS && app.website_search_suggestions.has( "google_code" ) ) {
					suggestions.push( {
				 		content : stext+" [Google Code]",
				 		description : [ "Search \"<match>", stext, "</match>\" at <match><url>Google Code</url></match> - <url>http://www.google.com/codesearch?q=", StringTools.urlEncode(stext), "</url>" ].join( '' )
				 	});
				}
				if( suggestions.length < MAX_SUGGESTIONS && app.website_search_suggestions.has( "google_development" ) ) {
					suggestions.push( {
				 		content : stext+" [Google development]",
				 		description : [ "Search \"<match>", stext, "</match>\" at <match><url>Google Develoment Search</url></match> - <url>http://www.google.com/cse?cx=005154715738920500810:fmizctlroiw&amp;q=", StringTools.urlEncode( stext ), "</url>" ].join( '' )
				 	});
				}
			}
		}
		suggest( suggestions );
	}
	
	/*
	function filterPlatform( root : TypeRoot ) : TypeRoot {
		var r = new Array<TypeTree>();
		for( tree in root ) {
			switch( tree ) {
			case TPackage(n,f,subs) :
			case TTypedecl(t) :  if( !filterTypePlatform(t) ) r.push(tree);
			case TEnumdecl(e) :  if( !filterTypePlatform(e) ) r.push(tree);
			case TClassdecl(c) : if( !filterTypePlatform(c) ) r.push(tree);
			}
		}
		return r;
	}
	
	function filterTypePlatform( d : Dynamic) : Bool {
		if( d.platforms != null ) {
			var it : Iterator<String> = d.platforms.iterator();
			for( p in it ) {
				if( Lambda.has( app.haxe_targets, p ) ) {
					return true;
				}
			}
			return false;
		}
		return true;
	}
	*/
	
	function addSuggestion( suggestions : Array<SuggestResult>, c : Dynamic ) {
		/*
		var allowed = false;
		var pf : List<String> = c.platforms;
		for( p in pf ) {
			for( t in app.haxe_targets ) {
				if( t == p ) {
					allowed = true;
					break;
				}
			}
			if( allowed )
				break;
		}
		if( !allowed )
			return;
		*/
		var path : String = c.path.split( "." ).join( "/" ).toLowerCase();
		var i = c.path.lastIndexOf( "." );
		var name = ( i == -1 ) ? c.path : c.path.substr( i+1 );
		if( path.startsWith( "flash" ) ) // hacking flash9 target path
			path = "flash9"+path.substr(5);
		var url = docpath + path;
		var description =  "<match>"+c.path+"</match>";
		//if( c.path != name ) description += " ("+c.path+")";
		if( c.doc != null && c.doc != "" ) {
			/*
			var s = c.doc.trim();
			var r = ~/(<.+>)/;
			s = r.replace( s, "" );
			s = s.replace( "\n", " " );
			//if( s.length > 68 )
			//	s = s.substr(0,64)+" ...";
			description += " - "+s;
			*/
		}
		description += " <url><dim>"+url+"</dim></url>";
		suggestions.push( { content : url, description: description } );
		//return { content : url, description: description };
	}
	
	function onInputEntered( text : String ) {
		trace( "Input entered: '"+text+"'" );
		if( text == null ) {
			//nav( docpath );
			return;
		}
		var stext = text.trim();
		/* 
		if( stext == null ) {
			nav( "http://haxe.org/api" );
			return;
		}
		*/
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
		if( stext.endsWith( suffix = " [Google development]" ) ) {
			App.nav( "http://www.google.com/cse?cx=005154715738920500810:fmizctlroiw&q=haxe "+formatSearchSuggestionQuery( stext, suffix ) );
			return;
		}
	}
	
	function setDefaultSuggestion( ?text : String ) {
		var d = '<url><match>HaXe</match></url>';
		if( text != null ) d +=  " "+text;
		chrome.Omnibox.setDefaultSuggestion( { description : d } );
	}
	
	function formatSearchSuggestionQuery( t : String, suffix : String ) : String {
		return t.substr( 0, t.length - suffix.length ).trim().urlEncode();
	}
	
}
