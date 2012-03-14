﻿// com.dave.ChromeRewindBtn
// Dave Cole
//
//	Represents a rewind button for a given media player.
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
	
	public class ChromeRewindBtn extends Chrome {
		public var inner:ChromeRewindBtnAsset;
		public var btn, btn_roll:Sprite;
		
		public function ChromeRewindBtn(initObj:Object){
			super(initObj);
			init();
		}
		
		public function init(){
			//this.visible = false;
			trace("ChromeRewindBtn() init");
			inner = new ChromeRewindBtnAsset();
			addChild(inner);
			btn = inner.btn;
			btn_roll = inner.btn_roll;
			
			btn_roll.visible = false;
			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, fs_mouse);
			this.addEventListener(MouseEvent.MOUSE_OUT, fs_mouse);
			this.addEventListener(MouseEvent.CLICK, fs_mouse);
			
			
		}
		
		public override function lateInit(e:Event){
			
		}
		
		private function fs_mouse(e:MouseEvent){
			switch(e.type){
				case MouseEvent.CLICK:
					dispatchEvent(new ChromeEvent(ChromeEvent.CONTROLEVENT, { type: "rewind" } ));
					break;
				case MouseEvent.MOUSE_OVER:
					btn_roll.visible = true;
					btn.visible = false;
					break;
				case MouseEvent.MOUSE_OUT:
					btn_roll.visible = false;
					btn.visible = true;
					break;
			}
		}
		
	}
}