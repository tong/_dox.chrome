package dox.chrome;

class Options {
	
	static var app : dox.chrome.IApp;
	
	static function init() {
		
		app = chrome.Extension.getBackgroundPage().instance;
		
		#if DEBUG
		haxe.Log.trace = mytrace;
		trace( "DOX.options" );
		#end
		
		/*
		j( '#btn_loadapi' ).click(function(e) {
			//app.loadAPI();
		});
		*/	
		
		/* 
		var j_maxsuggestions = j( '#maxsuggestions' ).val( Std.string( app.maxSuggestions ) );
		var j_maxsuggestions_d = j( '#maxsuggestions_display' ).html( Std.string( app.maxSuggestions ) );
		j_maxsuggestions.change(function(e){
			j_maxsuggestions_d.html( j_maxsuggestions.val() );
		});
		*/
		
		searchSuggestionSetup( 'HaxeOrg' );
		searchSuggestionSetup( 'GoogleCode' );
		searchSuggestionSetup( 'GoogleDevelopment' );
		searchSuggestionSetup( 'Stackoverflow' );
	}
	
	static function searchSuggestionSetup( field : String ) {
		var f = 'use'+field+'Search'; 
		var e = j( '#'+field.toLowerCase()+'search' );
		e.attr( 'checked', ( Reflect.field( app, f ) ) ? "true" : null );
		e.change(function(ev){
			Reflect.setField( app, f, e.is( ':checked' ) );
			Settings.save( app );
		});
	}
	
	static inline function j( id : String ) : js.JQuery { return new js.JQuery( id ); }

	#if DEBUG
	static inline function mytrace( v : Dynamic, ?inf : haxe.PosInfos ) { app.log( v, inf ); }
    #end
    
}
