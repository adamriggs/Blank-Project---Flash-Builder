package com.dave.utils {
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

    public class HTTPPost extends Sprite {
		private var loader:URLLoader = new URLLoader();
		
     	public function HTTPPost(){
			
		}
		

		public function load(url:String, vars:String):void{
			var request : URLRequest = new URLRequest(url);   

			request.method = URLRequestMethod.GET;   
			var variables : URLVariables = new URLVariables();   
			variables.data = vars;
			request.data = variables;   
			
			loader.addEventListener(Event.COMPLETE, on_complete);   
			loader.load(request);  
		}

		private function on_complete(e : Event):void{   
		    trace("HTTPPost: POST Complete"); 
		}  
    }
}