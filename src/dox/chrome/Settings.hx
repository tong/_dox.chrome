package dox.chrome;

typedef Settings = {
	var use_omnibox : Bool;
	//var packages : Array<String>;
	var haxe_targets(default,null) : Array<String>;
	var website_search_suggestions(default,null) : Array<String>;
}

/*
class Settings {
	
	public var data(default,null) : TSettings;
	
	public function new() {
		var d = LocalStorage.getItem( "settings" );
		if( d == null ) {
			data = {
				omnibox : true,
				packages : ["haxe","flash","js","neko","php"]
				//website_search_suggestions
			};
			save();
		} else {
			data = JSON.parse( d );
		}
	}
	
	public function save() {
		LocalStorage.setItem( "settings", JSON.stringify( data ) );
	}
	
	#if DEBUG
	public function toString() : String {
		return Std.string( data );
	}
	#end
	
}
*/
