// com.dave.ChromeQualityBtn
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
	
	public class ChromeQualityBtn extends Chrome {
		public var inner:ChromeQualityBtnAsset;
		public var hd_btn:MovieClip;
		public var hd_btn_roll:MovieClip;
		public var hq_btn:MovieClip;
		public var hq_btn_roll:MovieClip;
		private var origWidth:Number;
		private var isHD:Boolean = true;
		
		public function ChromeQualityBtn(initObj:Object){
			super(initObj);
			init();
		}
		
		public function init():void{
			//this.visible = false;
			trace("ChromeQualityBtn() init");
			inner = new ChromeQualityBtnAsset();
			addChild(inner);
			hd_btn = inner.hd_btn;
			hd_btn_roll = inner.hd_btn_roll;
			hq_btn = inner.hq_btn;
			hq_btn_roll = inner.hq_btn_roll;
			
			
			hd_btn.buttonMode = hd_btn_roll.buttonMode = hq_btn.buttonMode = hq_btn_roll.buttonMode = true;
			trace('a');
			hd_btn.addEventListener(MouseEvent.CLICK, btn_mouse);
			hd_btn_roll.addEventListener(MouseEvent.CLICK, btn_mouse);
			hq_btn.addEventListener(MouseEvent.CLICK, btn_mouse);
			hq_btn_roll.addEventListener(MouseEvent.CLICK, btn_mouse);
			trace('b');
			hd_btn.visible = hq_btn.visible = hq_btn_roll.visible = false;
			hd_btn_roll.visible = true;
			/*
			origWidth = width;
			width = 0;
			visible = false;
			parent.updateSize();
			*/
		}
		
		public override function lateInit(e:Event):void{
			
		}
		
		protected override function onPlaybackEvent(e:ChromeEvent):void{
			if (e.args.type == "qualitytype"){
				// qualityType & hilighted
				if (e.args.qualityType == "hd"){
					width = origWidth;
					visible = true;
					if (e.args.hilighted){
						hd_btn_roll.visible = true;
						hd_btn.visible = false;
						hq_btn.visible = false;
						hq_btn_roll.visible = false;
					} else {
						hd_btn_roll.visible = false;
						hd_btn.visible = true;
						hq_btn.visible = false;
						hq_btn_roll.visible = false;
					}
				} else if (e.args.qualityType == "hq"){
					width = origWidth;
					visible = true;
					if (e.args.hilighted){
						hd_btn_roll.visible = false;
						hd_btn.visible = false;
						hq_btn.visible = false;
						hq_btn_roll.visible = true;
					} else {
						hd_btn_roll.visible = false;
						hd_btn.visible = false;
						hq_btn.visible = true;
						hq_btn_roll.visible = false;
					}
				} else {
					width = 0;
					visible = false;
					
				}
				dispatchEvent(new ChromeEvent(ChromeEvent.CONTROLEVENT, { type: "updatesize" } ));
			} else if (e.args.type == "quality"){
				if (e.args.hilighted){
					if (isHD){
						hd_btn.visible = false;
						hd_btn_roll.visible = true;
					} else {
						hq_btn.visible = false;
						hq_btn_roll.visible = true;
					}
				} else {
					if (isHD){
						hd_btn.visible = true;
						hd_btn_roll.visible = false;
					} else {
						hq_btn.visible = true;
						hq_btn_roll.visible = false;
					}
				}
			}
		}
		
		
		private function btn_mouse(e:MouseEvent):void{
			switch(e.currentTarget.name){
				case "hd_btn":
					dispatchEvent(new ChromeEvent(ChromeEvent.CONTROLEVENT, { type: "quality", value: "hd720" } ));
					break;
				case "hd_btn_roll":
					dispatchEvent(new ChromeEvent(ChromeEvent.CONTROLEVENT, { type: "quality", value: "medium" } ));
					break;
				case "hq_btn":
					dispatchEvent(new ChromeEvent(ChromeEvent.CONTROLEVENT, { type: "quality", value: "large" } ));
					break;
				case "hq_btn_roll":
					dispatchEvent(new ChromeEvent(ChromeEvent.CONTROLEVENT, { type: "quality", value: "medium" } ));
					break;
			}
		}
	}
}