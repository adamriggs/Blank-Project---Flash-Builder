// com.dave.ChromeCollection
// Dave Cole
//
// A ChromeCollection is a container class that allows you to gather several different chrome elements into one collection, allowing them to be added and scaled as a group.
//
package com.dave.mediaplayers.chrome {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.*;
	
	import com.dave.mediaplayers.chrome.*;
	import com.dave.mediaplayers.chrome.events.*;
	
	public class ChromeCollection extends Chrome {
		protected var chrome:Array;
		private var i:int;
		private var j:int;
		private var lastWidth:Number = -1;
		
		public function ChromeCollection(initObj:Object){
			super(initObj);
			chrome = new Array();
			
			init();
		}
		
		public function init():void{
			trace("ChromeCollection() init");
			
		}
		
		public override function lateInit(e:Event):void{
			
		}
		
		public function addChrome(c:Chrome):void{
			if (c is ChromeScrubber){
				addChild(c);
			} else {
				addChildAt(c,0);
				//addChild(c);
			}
			c.addEventListener(ChromeEvent.CONTROLEVENT, onControlEvent);
			chrome.push(c);
		}
		
		public function removeChrome(c:Chrome):void{
			for(i=0; i < chrome.length; i++){
				if (chrome[i] == c){
					chrome[i].destroy(); // destroy removes the child
					chrome[i] = null;
					chrome.splice(i, 1);
				}
			}
		}
		
		public function removeAllChrome():void{
			for (i=0; i < chrome.length; i++){
				chrome[i].destroy(); // destroy removes the child
				chrome[i] = null;
			}
			chrome = new Array();
		}
		
		protected override function onPlaybackEvent(e:ChromeEvent):void{
			// pass event on to children
			dispatchEvent(new ChromeEvent(e.type, { type: e.args.type, value: e.args.value } ));
		}
		
		protected function onControlEvent(e:ChromeEvent):void{
			// pass event up to parent (which is listening via the super constructor)
			dispatchEvent(new ChromeEvent(e.type, { type: e.args.type, value: e.args.value } ));
		}
		
		
		// arrange x positions and widths of all child chrome, scaling the scrubber dynamically based on remaining width.
		public override function setWidth(width:Number):void{
			trace("cc.setWidth("+width+")");
			if (width != lastWidth){
				lastWidth = width;
			
				for (i=0; i < chrome.length; i++){
					
					if (i == 0){
						chrome[i].x = 0 + chrome[i].leftPadding;
					} else {
						if (chrome[i - 1] is ChromeScrubber){
							//chrome[i].x = chrome[i - 1].x + (chrome[i - 1].width - chrome[i - 1].nub.width/2) + chrome[i - 1].rightPadding + chrome[i].leftPadding;
							chrome[i].x = chrome[i - 1].x + (chrome[i - 1].well.width) + chrome[i - 1].rightPadding + chrome[i].leftPadding;
						} else {
							chrome[i].x = chrome[i - 1].x + chrome[i - 1].width + chrome[i - 1].rightPadding + chrome[i].leftPadding;
						}
					}
					
					if (chrome[i] is ChromeScrubber){
						// if scrubber, set width = to available remaining width - all trailing widths
						var rightWidth:Number = 0;
						for (j=(i + 1); j < chrome.length; j++){
							rightWidth += (chrome[j].width + chrome[j].leftPadding + chrome[j].rightPadding);
						}
						//trace("rightWidth == "+rightWidth);
						chrome[i].setWidth(Math.max(0, width - (chrome[i].x + chrome[i].leftPadding + chrome[i].rightPadding + rightWidth)));
					}
				}
			}
		}
		
		public override function destroy():void{
			removeAllChrome();
			_parent.removeEventListener(ChromeEvent.PLAYBACKEVENT, onPlaybackEvent);
			_parent.removeChild(this);
		}
		
		public override function show():void{
			this.visible = true;
		}
		
		public override function hide():void{
			this.visible = false;
		}
		
	
	}
}