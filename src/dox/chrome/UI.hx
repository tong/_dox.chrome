package dox.chrome;

class UI {
	
	public static function desktopNotification( title : String, m : String, time : Int = 3000 ) {
		//Notification.show( "DoX "+title, m, time, "img/icon_48.png");
		var n = chrome.Notifications.createNotification( "img/icon_48.png", "DoX "+title, m );
		n.show();
	}
	
}
