/*
// com.dave.panels.Thumbnail
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
//
// Defines a base class for a thumbnail to be used by the Thumbnail Scroller; should be extended.
//
*/

package com.dave.panels {
	import flash.display.*;
	import flash.events.*;
	import caurina.transitions.*;
	
	public class Thumbnail extends Sprite {
		
		public var myPosition:int;
		
		public function Thumbnail(){
			trace("new Thumbnail()");
		}
		
		public function populate(dataObj:Object):void{
			trace("Thumbnail.populate("+dataObj+")");
		}
	}
}