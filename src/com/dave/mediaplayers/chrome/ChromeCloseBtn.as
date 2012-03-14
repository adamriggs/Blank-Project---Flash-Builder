// com.dave.ChromeCloseBtn
// Dave Cole
//
//	Represents a close button for a given media player.
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
	
	public class ChromeCloseBtn extends Chrome {
		public var inner:ChromeCloseBtnAsset;
		public var btn, btn_roll:Sprite;
		
		public function ChromeCloseBtn(initObj:Object){
			super(initObj);
			init();
		}
		
		public function init(){
			//this.visible = false;
			trace("ChromeCloseBtn() init");
			inner = new ChromeCloseBtnAsset();
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
					dispatchEvent(new ChromeEvent(ChromeEvent.CONTROLEVENT, { type: "stop" } ));
					// *** put in custom code to close your video player here.
					EventCenter.broadcast("onCloseBigPlayer", {});
					
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