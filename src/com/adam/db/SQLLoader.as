// com.app.SQLLoader
// Adam Riggs
//
package com.adam.db {
	//import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.events.*;
	
	//import gs.TweenMax;
	
	import com.adam.utils.AppData;
	import com.adam.events.MuleEvent;
	
	public class SQLLoader {
		
		private var appData:AppData=AppData.instance;
		
		private var _reciever:String;
		private var _url:String;
		private var _vars:URLVariables;
		private var _error:Boolean;
		private var _success:Boolean;
		private var _working:Boolean;
		private var _errorMsg:String;
		
		private var urlLoader:URLLoader;
		private var urlRequest:URLRequest;
		
		public function SQLLoader(r:String,u:String,v:URLVariables){
			_reciever=r;
			_url=u;
			_vars=v;
			init();
		}
		
//*****Initialization Routines
		
		public function init():void{
			//this.visible = false;
			debug("SQLLoader() init");
			debug("reciever=="+reciever);
			
			initURLLoader();
			initURLRequest();
			initState();
			beginLoad();
		}
		
		private function initURLLoader():void{
			urlLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		private function initURLRequest():void{
			urlRequest=new URLRequest(_url);
			urlRequest.method=URLRequestMethod.POST;
			urlRequest.data=_vars;
		}
		
		private function initState():void{
			_error=false;
			_success=false;
			_working=false;
			_errorMsg="";
		}
		
//*****Core Functionality
		
		public function beginLoad():void{
			//initiate the loading process
			urlLoader.load(urlRequest);
			_working=true;
		}
		
		
//*****Event Handlers
		
		private function onComplete(e:Event):void{
			//if the loading completes successfully
			_error=false;
			_success=true;
			_working=false;
			debug("query complete");
			//debug("sql data: "+e.currentTarget.data);
			debug("url=="+_url);
			appData.eventManager.dispatch(_reciever, {type:"sqlResult", xml:e.currentTarget.data, url:_url});
		}
		
		private function onError(e:IOErrorEvent):void{
			//if there's an error when loading
			_errorMsg=e.text;
			debug("sql error: "+_errorMsg);
			
			_error=true;
			_success=false;
			_working=false;
		}
		
//*****Gets and Sets
		
		public function get reciever():String{return _reciever;}
		public function set reciever(value:String):void{_reciever=value;}
		
		public function get url():String{return _url;}
		public function set url(value:String):void{_url=value;}
		
		public function get vars():URLVariables{return _vars;}
		public function set vars(value:URLVariables):void{_vars=value;}
		
		public function get error():Boolean{return _error};
		public function get working():Boolean{return _working};
		public function get success():Boolean{return _success};
		public function get errorMsg():String{return _errorMsg};
		
//*****Utility Functions
		
		//**debug
		private function debug(str:String):void{
			trace(str);
			appData.eventManager.dispatch("debug", {msg:str, sender:"SQLLoader"});
		}
		
		
	}
}