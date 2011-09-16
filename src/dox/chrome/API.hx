package dox.chrome;

import js.Node;
import js.JSON;

/**
	Generates the API description file.
	Be sure to generate/update the XML type descriptions before running this (haxe api.hxml).
*/
class API {

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
	
}
