package dox.chrome;

class Settings {
	
	public static inline function load() : TSettings {
		return JSON.parse( LocalStorage.getItem( "settings" ) );
	}
	
	public static inline function save( data : TSettings ) {
		LocalStorage.setItem( "settings", JSON.stringify( data ) );
	}
}
