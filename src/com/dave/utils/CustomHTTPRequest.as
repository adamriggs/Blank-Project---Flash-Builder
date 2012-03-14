package com.dave.utils {
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

    public class CustomHTTPRequest extends Sprite {
		private var loader:URLLoader;
		private var header,header2:URLRequestHeader;
		private var request:URLRequest;
		
        public function CustomHTTPRequest() {
            loader = new URLLoader();
            configureListeners(loader);

           ///	header = new URLRequestHeader("Content-Type", "*application/json*");  // text/json, mediaType
			//header2 = new URLRequestHeader("pragma", "no-cache");
            

           
        }
		
		public function load(url:String, str:String, requesttype:String=URLRequestMethod.POST):void{
			request = new URLRequest(url);
            request.data = new URLVariables("data="+str); // new URLVariables("format=JSON");
            request.method = requesttype; //URLRequestMethod.POST;
           // request.requestHeaders.push(header);
			//request.requestHeaders.push(header2);
			
			 try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
            }
		}
		
        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            trace("completeHandler: " + loader.data);
			//var e:Event = new Event(Event.COMPLETE);
			//e.target = loader;
			dispatchEvent(event);
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }
    }
}