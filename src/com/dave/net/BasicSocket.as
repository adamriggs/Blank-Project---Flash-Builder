package com.dave.net{
	
	import flash.events.*;
	import flash.net.Socket;
	import flash.utils.*;
	import flash.text.TextField;

	public class BasicSocket extends Socket {

		private var pnl:TextField;
		

		public function BasicSocket(host:String = null, port:uint = 8888, view:TextField = null) {
			try {
				super(host, port);
			} catch (e:Error){
				trace("Cannot Connect Locally");
			} finally {
				pnl = view;
				addEventListener(Event.CONNECT, onConnect);
				addEventListener(Event.CLOSE, onClose);
				addEventListener(IOErrorEvent.IO_ERROR, onError);
				addEventListener(ProgressEvent.SOCKET_DATA, onResponse);
			}
		}
		
		private function onConnect(e:Event):void {
			trace('connected');
			
		}
		
		private function onClose(e:Event):void {
			trace('closed');
			
		}
		
		private function onError(e:IOErrorEvent):void {
			trace('connection error');
			
		}
		
		private function onResponse(e:ProgressEvent):void{
			var str:String = readUTFBytes(bytesAvailable); 
			trace('server response: '+str);
		} 
		
		public function send(str:String):void{ 
			if (connected){
				writeUTFBytes(str); 
				flush();
			}
		}
	}
}