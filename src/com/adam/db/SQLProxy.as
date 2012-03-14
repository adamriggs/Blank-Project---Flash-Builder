// com.app.SQLProxy
// Adam Riggs
//
package com.adam.db {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLVariables;
	
	//import gs.TweenMax;
	
	import com.adam.utils.AppData;
	import com.adam.events.MuleEvent;
	
	public class SQLProxy extends Sprite {
		
		private var appData:AppData=AppData.instance;
		
		private var _baseURL:String;
		private var _insertURL:String;
		private var _updateURL:String;
		private var _deleteURL:String;
		private var _queryURL:String;
		
		private var _sqlLoaderArray:Array;
		
		private var _check:Boolean;
		
		private static const _instance:SQLProxy=new SQLProxy(SQLProxyLock);
		
		public function SQLProxy(lock:Class){
			if ( lock != SQLProxyLock )
			{
				throw new Error( "Invalid SQLProxy access.  Use SQLProxy.instance." );
			}
			//init();
		}
		
//*****Initialization Routines
		
		public function init():void{
			//this.visible = false;
			debug("SQLProxy() init");
			
			
			initURLs();
			initSQLLoaderArray();
		}
		
		public function initURLs():void{
			//_baseURL="http://adamriggs.com/clients/fuisz/db/";
			_baseURL=appData.mainXML.DBPATH;
			_insertURL=baseURL+"insert.php";
			_updateURL=baseURL+"update.php";
			_deleteURL=baseURL+"delete.php";
			_queryURL=baseURL+"query.php";
		}
		
		private function initSQLLoaderArray():void{
			_sqlLoaderArray=new Array();
		}
		
//*****Core Functionality
		
		public function insertSQL(reciever:String,vars:URLVariables):void{
			_sqlLoaderArray.push(new SQLLoader(reciever,_insertURL, vars));
		}
		
		public function updateSQL(reciever:String,vars:URLVariables):void{
			_sqlLoaderArray.push(new SQLLoader(reciever,_updateURL, vars));
		}
		
		public function deleteSQL(reciever:String,vars:URLVariables):void{
			_sqlLoaderArray.push(new SQLLoader(reciever,_deleteURL, vars));
		}
		
		public function querySQL(reciever:String,vars:URLVariables):void{
			_sqlLoaderArray.push(new SQLLoader(reciever,_queryURL, vars));
		}
		
		public function checkArrayForErrors():Boolean{
			var _check:Boolean=false;
			
			for(var i:uint=0;i<_sqlLoaderArray.length;i++){
				if(_sqlLoaderArray[i].error==true){_check=true;}
			}
			
			return _check;
		}
		
		public function checkArrayStillWorking():Boolean{
			var _check:Boolean=false;
			
			for(var i:uint=0;i<_sqlLoaderArray.length;i++){
				if(_sqlLoaderArray[i].working==true){_check=true;}
			}
			
			return _check;
		}
		
		public function checkArrayEverythingDone():Boolean{
			var _check:Boolean=true;
			
			for(var i:uint=0;i<_sqlLoaderArray.length;i++){
				if(_sqlLoaderArray[i].success==false){_check=false;}
			}
			
			return _check;
		}
		
//*****Event Handlers
		
		
		
//*****Gets and Sets
		
		public function get baseURL():String{return _baseURL;}
		public function set baseURL(value:String):void{_baseURL=value;}
		
		public function get insertURL():String{return _insertURL;}
		public function set insertURL(value:String):void{_insertURL=_baseURL+value;}
		
		public function get updateURL():String{return _updateURL;}
		public function set updateURL(value:String):void{_updateURL=_baseURL+value;}
		
		public function get deleteURL():String{return _deleteURL;}
		public function set deleteURL(value:String):void{_deleteURL=_baseURL+value;}
		
		public function get queryURL():String{return _queryURL;}
		public function set queryURL(value:String):void{_queryURL=_baseURL+value;}
		
		public function get sqlLoaderArray():Array{return _sqlLoaderArray;}
		
		public static function get instance():SQLProxy{return _instance;}
		
//*****Utility Functions
		
		public function show():void{
			this.visible = true;
		}
		
		public function hide():void{
			this.visible = false;
		}
		
		//**debug
		private function debug(str:String):void{
			trace(str);
			appData.eventManager.dispatch("debug", {msg:str, sender:"SQLProxy"});
		}
		
	
	}
}

class SQLProxyLock
{
}