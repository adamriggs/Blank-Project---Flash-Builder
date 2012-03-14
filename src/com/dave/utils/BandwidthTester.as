
// AS3 BandwidthTester class - measures the user's bandwidth in Kilobits/second down
// To start test: startTest(testMovieURL);
// To get results, write an onTestComplete function that does something with the numeric argument of Kb/sec that is returned.
// 
package com.dave.utils {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.utils.*;
	import flash.system.*;
	import com.app.Application;
	
	public class BandwidthTester{
	
		public var onTestComplete,onLoadUpdate:Function;
		
		public var loader:Loader;
		public var context:LoaderContext;
		public var info:LoaderInfo;
		public var file:String;
		private var nocachestr:String;
		private var startTime:uint;
		
		public function BandwidthTester(){
			
			initBT();
		}
		
		public function initBT():void{
			reset();
		}
		
		
		public function reset():void{
			loader = new Loader();
			context = new LoaderContext(true);
			context.checkPolicyFile = true;
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleInit );
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.addEventListener( Event.OPEN, setStartTime );
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgress );
			
			onLoadUpdate = function(n:Number){ }
			
			startTime = 0;
			
		}
		
		public function kill():void{
			
			try { loader.close(); } catch (e:Error){ } finally { }
			try { loader.unload(); } catch (e:Error){ } finally { }
			
		}
		
		public function getkbps(startTime,sizeInBytes):int {
			trace("getkbs("+startTime+", "+sizeInBytes+")");
			var elapsedTimeMS = getTimer() - startTime; // time elapsed since start loading swf
			var elapsedTime = elapsedTimeMS/1000; //convert to seconds
			trace("elapsedTime = "+elapsedTime);
			var sizeInBits = sizeInBytes * 8; // convert Bytes to bits,
			var sizeInKBits = sizeInBits/1024; // convert bits to kbits
			trace("sizeInKBits = "+sizeInKBits);
			var kbps = (sizeInKBits/elapsedTime) * 0.93 ; // IP packet header overhead around 7%
			return(Math.floor(kbps)); // return user friendly number
			
		}
		
		public function startTest(testURL:String):void{
			var now = new Date(); // create date object
	
			if(Capabilities.playerType == "External"){
				nocachestr = "";
				//nocachestr = "?" + now.getTime();
			} else {
				nocachestr = "?" + now.getTime();
			}
			
			file = testURL+nocachestr;
			trace("BandwidthTester: Loading "+file);
			loader.load(new URLRequest(testURL+nocachestr)); //,context);
		}
	
	
		public function onProgress(event:ProgressEvent):void{
			trace(event.target + ".onLoadProgress with " + event.bytesLoaded + " bytes of " + event.bytesTotal);
	
			onLoadUpdate(event.bytesLoaded/event.bytesTotal);
		}
	
		public function setStartTime(event:Event):void{
			startTime = getTimer();
		}
	
		public function handleInit(event:Event):void{
			try {
				//addChild(inner);
				trace("com.dave.utils.BandwidthTester: File loaded.");
				onTestComplete(getkbps(startTime,loader.contentLoaderInfo.bytesTotal));
			
			} catch ( e:TypeError ){
				trace("com.dave.utils.BandwidthTester: ERROR loading File '"+file+"': "+e.message);
				onTestComplete(-1);
			}
		}
		
		public function ioErrorHandler(e:IOErrorEvent):void{
			trace("com.dave.utils.BandwidthTester: ioError loading file "+file+ ": "+e.text);
			onTestComplete(-1);
		}
	
	}
}

