// com.dave.ChromeAsset
// Dave Cole
//
//	Represents an embed button for a given media player.
// 
// Expected Skin Elements:
//	btn			- Embed button icon
//	btn_roll	- Embed Screen button roll-over state
//
// Inherited functions:
//	show();
//	hide();
//	all other functions are overridden below.
//
package com.dave.mediaplayers.chrome {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.*;
	
	import com.dave.mediaplayers.chrome.events.*;
	
	public class ChromeAsset extends Chrome {
		public var asset:String;
		protected var mySprite:Sprite;
		
		public function ChromeAsset(initObj:Object){
			super(initObj);
			init();
		}
		
		public function init():void{
			//this.visible = false;
			trace("ChromeAsset() init");
			
			var myClass:Class = getDefinitionByName(asset) as Class;
			mySprite = new myClass();
			addChild(mySprite);
			
			
		}
		
		public override function lateInit(e:Event):void{
			
		}
		
		
		
	}
}