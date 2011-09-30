package dox.chrome;

#if nodejs
import js.Node;
import js.JSON;
#elseif neko
import hxjson2.JSON;
#end

/**
	Generates the API description file.
	Be sure to generate/update the XML type descriptions before running this (haxe api.hxml).
*/
class API {
	
	#if nodejs
	
	static var targets = ["flash","js","neko","php"];
		
	public static function main() {
	
		// generate xml files here (?)
		//TODO generate here .. do not use the hxml files
		
		var timestamp = haxe.Timer.stamp();
		log( "Generating type description file for targets: "+targets );
		var parser = new haxe.rtti.XmlParser();
		for( t in targets ) {
			js.Node.sys.print( "  "+t+" .. " );
			var x = Xml.parse( Node.fs.readFileSync( "api/"+t+".xml", Node.UTF8 ) ).firstElement();
			parser.process( x, t );
			js.Node.sys.print( "done\n" );
		}
		parser.sort();
		log( "Writing JSON file ..." );
		Node.fs.writeFileSync( "haxe_api", JSON.stringify( parser ) );
		log( "Done ("+(haxe.Timer.stamp()-timestamp)+")" );
	}
	
	static inline function log( t : String ) Node.console.log(t) 
	
	#elseif neko
	
	static var targets = ["flash","js","neko","php"];
	
	public static function main() {
		var timestamp = haxe.Timer.stamp();
		log( "Generating type description file for targets: "+targets );
		var parser = new haxe.rtti.XmlParser();
		for( t in targets ) {
			neko.Lib.print( "  "+t+" .. " );
			var x = Xml.parse( neko.io.File.getContent( "api/"+t+".xml") ).firstElement();
			parser.process( x, t );
			neko.Lib.print( "done\n" );
		}
		parser.sort();
		log( "Writing JSON file ..." );
		var fo = neko.io.File.write( "haxe_api2" );
		fo.writeString( new JSONEncoder(parser).getString()  );
		//fo.writeString( JSON.stringify( parser )  ); // creates invalid JSON string
		fo.close();
		
		log( "Done ("+(haxe.Timer.stamp()-timestamp)+")" );
	}
	
	static inline function log( t : String ) neko.Lib.println(t) 
	
	#end
	
}
