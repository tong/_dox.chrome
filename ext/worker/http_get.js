onmessage = function(e){
	var r = new XMLHttpRequest();
	r.open( "GET", e.data, true, null, null );
	r.onreadystatechange = function(){
		if( r.readyState != 4 )
			return;
		var s = r.status;
		if( s != null && s >= 200 && s < 400 )
			postMessage( r.responseText );
		else
			postMessage();
	};
	r.send();
}
