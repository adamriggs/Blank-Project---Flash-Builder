// com.app.FlashMediaServer
// Adam Riggs
//
package com.adam.fms {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	
	import gs.TweenMax;
	
	import com.adam.utils.AppData;
	import com.adam.events.MuleEvent;
	
	public class FlashMediaServer extends Sprite {
		
		//my centralized data warehouse
		private var appData:AppData=AppData.instance;
		
		//NetConnection/NetStream
		public var nc:NetConnection;
		public var ns:NetStream;
		
		//control variables
		private var _uri:String;
		private var _isPlaying:Boolean;
		private var updateTimer:Timer;
		private var updateInterval:Number;
		private var _connected:Boolean;
		
		//client objects
		public var connectionClient:Object;
		public var streamClient:Object;
		
		//video data
		public var _metaData:Object;
		
		//tmp vars for calculating the time it take to make a nc
		private var ncStart:String;
		private var ncStop:String;
		private var ncTotal:uint;
		
		private static const _instance:FlashMediaServer = new FlashMediaServer(fmsLock);
		
		public function FlashMediaServer(lock:Class){
			
			// Verify that the lock is the correct class reference.
			if (lock != fmsLock){
				throw new Error("Invalid FlashMediaServer access.  Use FlashMediaServer.instance.");
			}
			
			//init();
		}
		
//*****Initialization Routines
		
		public function init(){
			//this.visible = false;
			debug("FlashMediaServer() init");
			
			initVars();
			initEvents();
			initClientObjs();
			//initNetConnection();
			//initNetStream();	//this gets called after the nc reports a successful connection in onNetStatus
		}
		
		private function initVars():void{
			
			//uri of the FMS
			_uri="rtmp://ec2-50-17-71-65.compute-1.amazonaws.com/vod";
			//_uri="http://127.0.0.1/";
			
			//play state
			_isPlaying=false;
			
			_metaData=new Object();
			
			_connected=false;
			
		}
		
		private function initEvents():void{
			appData.eventManager.listen("fms", onFMS);
		}
		
		private function initClientObjs():void{
			debug("initClientObjs()");
			
			//**netconnection client
			connectionClient=new Object();
			
			connectionClient.onBWCheck=function(...rest):Number {
				debug("ConnectionClient onBWCheck");
				var key:Object;
				for (key in rest){
						debug("\t"+key + ": " + rest[key]);
				}
				
				return 0;
			}
			
			connectionClient.onBWDone=function(...rest):void{
				debug("ConnectionClient onBWDone "+rest);
				var key:Object;
				for (key in rest){
						debug("\t"+key + ": " + rest[key]);
				}
				var bandwidthTotal:Number;
				if (rest.length > 0){
					bandwidthTotal = rest[0];
					debug("bandwidth = " + bandwidthTotal + " Kbps.");
				}
			}
			
			//**netstream client
			streamClient=new Object();
			streamClient.onMetaData=function(infoObject:Object):void{
				debug("StreamClient metadata");
				_metaData=infoObject;
				appData.eventManager.dispatch("videoplayer", {type:"onMetaData", sender:"fms"});
				var key:String;
				for (key in infoObject){
						debug("\t"+key + ": " + infoObject[key]);
				}
			}
			
			streamClient.onCuePoint=function(infoObject:Object):void{
				debug("StreamClient cuePoint name:"+infoObject.name+" time:"+infoObject.time);
			}
			
			streamClient.onPlayStatus=function(infoObject:Object):void{
				debug("StreamClient playStatus");
				debug("\t"+infoObject.code);
			}
			
			streamClient.onTextData=function(infoObject:Object):void{
				debug("StreamClient textData");
				
			}
			
		}
		
		private function initNetConnection():void{
			debug("initNetConnection()");
			//initialize the NetConnection, add event listeners
			nc=new NetConnection();
			nc.client=connectionClient;
			nc.addEventListener(NetStatusEvent.NET_STATUS, onConnectionNetStatus);
            nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectionSecurityError);
			nc.addEventListener(IOErrorEvent.IO_ERROR, onConnectionIOError);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onConnectionAsyncError);
			
			//initiate the connection
			connect();
		}
		
		private function initNetStream():void{
			debug("initNetStream()");
			//initialize the NetStream
			ns=new NetStream(nc);
			ns.client=streamClient;
			ns.addEventListener(NetStatusEvent.NET_STATUS, onStreamNetStatus);
			ns.addEventListener(IOErrorEvent.IO_ERROR, onStreamIOError);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onStreamAsyncError);
			appData.eventManager.dispatch("videoplayer", {type:"netStreamInit", sender:"FlashMediaServer"});
		}
		
//*****Core Functionality
		
		//**NetConnection
		public function connect():void{
			nc.connect(uri);
			ncStart=new Date().toLocaleString();
			debug("connect() \n\tstartTime:"+ncStart);
			debug("\t URI=="+_uri);
		}
		
		public function closeConnection():void{
			debug("closeConnection()");
			nc.close();
		}
		
		//**NetStream
		public function closeStream():void{
			debug("closeStream()");
			ns.close();
			togglePauseSatus();
		}
		
		public function playStream(stream:String):void{
			debug("playStream()");
			ns.play(stream);
			//togglePauseSatus();
			_isPlaying=true;
		}
		
		public function pauseStream():void{
			debug("pauseStream()");
			ns.pause();
			//togglePauseSatus();
			_isPlaying=false;
		}
		
		public function resumeStream():void{
			debug("unpauseStream()");
			ns.resume();
			//togglePauseSatus();
			_isPlaying=true;
		}
		
		public function togglePause():void{
			debug("togglePause()");
			ns.togglePause();
			togglePauseSatus();
		}
		
		public function publishStream():void{
			debug("publishStream()");
			//nothing to see here...
		}
		
		private function togglePauseSatus():void{
			//toggles the _isPlaying boolean and starts/stops the update timer
			if(_isPlaying){
				_isPlaying=false;
			}else{
				_isPlaying=true;
			}
		}
		
//*****Event Handlers
		
		//**nc events
		public function onConnectionNetStatus(e:NetStatusEvent):void{
			debug("FlashMediaServer.nc onNetStatus e.info=="+e.info.code);
			
			switch(e.info.code){
				
				case "NetConnection.Connect.Success":
					ncStop=new Date().toLocaleString();
					_connected=true;
					debug("NetConnection.Connect.Success \n\tendTime:"+ncStop);
					//initNetStream();
				break;
				
				
			}
		}
		
		private function onConnectionSecurityError(e:SecurityErrorEvent):void{
			debug("FlashMediaServe.ncr onSecurityError e.text=="+e.text);
		}
		
		private function onConnectionIOError(e:IOErrorEvent):void{
			debug("FlashMediaServer.nc onIOError e.text=="+e.text);
			
		}
		
		private function onConnectionAsyncError(e:AsyncErrorEvent):void{
			debug("FlashMediaServer.nc onAsyncError e.text=="+e.text);
			
		}
		
		//**ns events
		public function onStreamNetStatus(e:NetStatusEvent):void{
			debug("FlashMediaServer.ns onNetStatus e.info=="+e.info.code);
			
			switch(e.info.code){
				
				case "NetConnection.Connect.Success":
					ncStop=new Date().toLocaleString();
					debug("NetConnection.Connect.Success \n\tendTime:"+ncStop);
					initNetStream();
				break;
				
				
			}
		}
		
		private function onStreamSecurityError(e:SecurityErrorEvent):void{
			debug("FlashMediaServe.ns onSecurityError e.text=="+e.text);
		}
		
		private function onStreamIOError(e:IOErrorEvent):void{
			debug("FlashMediaServer.ns onIOError e.text=="+e.text);
			
		}
		
		private function onStreamAsyncError(e:AsyncErrorEvent):void{
			debug("FlashMediaServer.ns onAsyncError e.text=="+e.text);
			
		}
		
		//**Flash Media Server event listeners for anyscronous control 
		private function onFMS(e:MuleEvent):void{
			
			switch(e.data.type){
				
				case "play":
					playStream(e.data.video);
				break;
				
				case "pause":
					pauseStream();
				break;
				
				case "resume":
					resumeStream();
				break;
				
				case "togglePause":
					togglePause();
				break;
				
			}
		}
		
//*****Gets and Sets
		
		public static function get instance():FlashMediaServer{return _instance;}
		
		public function get uri():String{return _uri;}
		public function set uri(value:String):void{_uri=value;}
		
		public function get isPlaying():Boolean{return _isPlaying;}
		
		public function get metaData():Object{return _metaData;}
		
		public function get connected():Boolean{return _connected;}
		
//*****Utility Functions
		
		//**debug
		private function debug(str:String):void{
			trace(str);
			appData.eventManager.dispatch("debug", {msg:str, sender:"FlashMediaServer"});
		}
	}
}


class fmsLock{
	
}