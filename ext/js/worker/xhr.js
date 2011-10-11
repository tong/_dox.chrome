onmessage = function(e){
	var url = e.data;
	var r = new XMLHttpRequest();
	r.open( "GET", e.data, false );
	r.send(null);
	if( r.status == 200 ) {
		postMessage(r.responseText);
	} else {
		postMessage( "error:"+r.status );
	}
}
