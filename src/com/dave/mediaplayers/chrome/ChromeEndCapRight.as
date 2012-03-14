﻿// com.dave.ChromeAsset
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
	import com.dave.mediaplayers.chrome.events.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	
	public class ChromeEndCapRight extends Chrome {
		public var inner:ChromeEndCapRightAsset;
		
		
		public function ChromeEndCapRight(initObj:Object){
			super(initObj);
			init();
		}
		
		public function init():void{
			//this.visible = false;
			trace("ChromeEndCapRight() init");
			inner = new ChromeEndCapRightAsset();
			addChild(inner);
			
		}
		
		public override function lateInit(e:Event):void{
			
		}
		
		
		
	}
}