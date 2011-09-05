package dox.chrome;

class Storage {
	
	public static inline function setObject( key : String, value : Dynamic ) {
		LocalStorage.setItem( key, JSON.stringify( value ) );
	}
	
	public static inline function getObject( key : String ) {
		return JSON.parse( LocalStorage.getItem( key ) );
	}
	
	/*
	public static function setObject( key : String, value : Dynamic, ?expiration : Float ) {
		if( expiration == null ) expiration = 3e9; // ~ 1 month
		if( expiration > 0 ) expiration += Date.now().getTime();
		LocalStorage.setItem( key, JSON.stringify( value ) );
		LocalStorage.setItem( key+"__expiration", expiration );
	}
	
	public static inline function getObject( key : String ) {
		return JSON.parse( LocalStorage.getItem( key ) );
	}
	
	public static function hasUnexpired( key : String ) : Bool {
		if( LocalStorage.getItem( key+"__expiration" ) == null || !LocalStorage.getItem( key ) == null )
			return false;
		var expiration = LocalStorage.getItem( key + "__expiration" );
		return expiration < Date.now().getTime();
	}
	*/
	
}
