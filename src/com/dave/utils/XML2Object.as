// XML2Object
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
// 
// Usage:
//
// xmlObj = new XML2Object( {filename } );
// 
// xmlObj.onLoaded = function(){ ... process xml using the XML2Object.xml ... }
//
// xmlObj.load(filename);
//

package com.dave.utils{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class XML2Object {
		public var loader:URLLoader;
		public var xml:XML;
		public var file:String;
		public var onLoaded:Function;
		
		public function XML2Object(...filename){
			loader = new URLLoader();
			//loader.dataFormat = DataFormat.TEXT;
			loader.addEventListener( Event.COMPLETE, handleComplete );
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			xml = null;
			
			if (filename.length > 0){
				load(filename[0]);
			} 
		}
		
		public function load(filename:String):void{
			file = filename;
			loader.load( new URLRequest(filename) );
		}
		
		private function handleComplete(event:Event):void{
			try {
				xml = new XML( event.target.data );
				this.onLoaded();
			} catch ( e:TypeError ){
				trace("com.dave.utils.XML2Object: ERROR loading XML File '"+file+"': "+e.message);
			}
		}
		
		private function ioErrorHandler(e:Event):void{
			trace("com.dave.utils.XML2Object: ERROR loading XML File '"+file);
		}
	}
}