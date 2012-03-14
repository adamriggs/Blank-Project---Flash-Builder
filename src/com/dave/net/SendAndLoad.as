// SendAndLoad.as - props to Tushar Wadekar for writing it
// PHP Script MUST return data/value pairs, i.e. success=1&variable2=blah&etc=3...

package com.dave.net{

	import flash.events.*;
	import flash.net.*;

	public class SendAndLoad {

		public function SendAndLoad() {
		}
		
		public function sendData(url:String, _vars:URLVariables):void {
			
			var request:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			//loader.dataFormat = URLLoaderDataFormat.TEXT;
			request.data = _vars;
			request.method = URLRequestMethod.POST;
			loader.addEventListener(Event.COMPLETE, handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(request);
			
			
		}
		
		private function handleComplete(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			trace("PHP Success: " + loader.data.success);
			
		}
		
		private function onIOError(event:IOErrorEvent):void {
			trace("Error loading URL.");
		}
	}
}