// com.dave.Chrome
// Dave Cole
//
// Base class for all media player chrome.
//
// leftPadding		- how many pixels to the left do you want room made for this Chrome?
// rightPadding		- how many pixels to the right do you want room made for this Chrome?
// align			- "left", "right", or "center"
//
package com.dave.mediaplayers.chrome {
	import com.dave.mediaplayers.chrome.events.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	
	public class Chrome extends Sprite {
		public var leftPadding:Number;
		public var rightPadding:Number;
		public var topPadding:Number;
		public var align:String; // can be left, right, center ** unimplemented due to context issues
		public var _parent:DisplayObjectContainer;
		
		public function Chrome(initObj:Object){   // initObj: { parent:DisplayObject, [ y: initY, width: initWidth, leftPadding: leftPadding, rightPadding: rightPadding, topPadding: topPadding, align: align ] }
			_parent = initObj.parent;
			leftPadding = 0;
			rightPadding = 0;
			topPadding = 0;
			align = "left";
			for (var obj in initObj){
				if (obj != "parent" && obj != "width" ){
					this[obj] = initObj[obj];
					trace("Chrome - this["+obj+"] = initObj["+obj+"] = "+initObj[obj]);
				} else if (obj == "width"){
					setWidth(initObj[obj]);
				}
			}
			
			x = leftPadding;
			y = topPadding;
			_parent.addEventListener(ChromeEvent.PLAYBACKEVENT, onPlaybackEvent);
			
		}
		
		
		
		protected function onPlaybackEvent(e:ChromeEvent):void{
			// *** OVERRIDE THIS FUNCTION TO HANDLE YOUR SPECIFIC PLAYBACK EVENT IN YOUR CHROME CODE
			// *** POTENTIAL VALUES OF e.args.type are: "playing", "paused", "stopped", "doneplaying", "bufering", "cuepoint", "duration", "headposition" (args of value: 0-1), "loadprogress" (args of value: 0-1)
		}
		
		public function lateInit(e:Event):void{
			
		}
		
		public function setSize(width:Number, height:Number):void{
			// ** override with your own resize code if need be
			y = height + topPadding;
			setWidth(width);
		}
		
		public function setWidth(width:Number):void{
			// ** override with width-specific placement code if need be
			
		}
		
		public function destroy():void{
			_parent.removeEventListener(ChromeEvent.PLAYBACKEVENT, onPlaybackEvent);
			_parent.removeChild(this);
		}
		
		public function show():void{
			this.visible = true;
		}
		
		public function hide():void{
			this.visible = false;
		}
		
	
	}
}