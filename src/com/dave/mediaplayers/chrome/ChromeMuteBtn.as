// com.dave.ChromeMuteBtn
// Dave Cole
//
// Represents a mute button for a media player.  
//
// Expected Skin Elements:
//	mute_btn			- Mute button icon
//	mute_btn_roll		- Mute button roll-over state
//	mute_btn_muted		- Mute button when muted icon
//	mute_btn_muted_roll	- Mute butotn when muted roll-over state
//
// inherited functions:
// show();
// hide();
//
package com.dave.mediaplayers.chrome {
	import com.dave.mediaplayers.chrome.events.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	
	public class ChromeMuteBtn extends Chrome {
		public var inner:ChromeMuteBtnAsset;
		public var mute_btn:MovieClip;
		public var mute_btn_roll:MovieClip;
		public var mute_btn_muted:MovieClip;
		public var mute_btn_muted_roll:MovieClip;
		private var muted:Boolean = false;
		
		public function ChromeMuteBtn(initObj:Object){
			super(initObj);
			init();
		}
		
		public function init():void{
			trace("ChromeMuteBtn() init");
			inner = new ChromeMuteBtnAsset();
			addChild(inner);
			mute_btn = inner.mute_btn;
			mute_btn_roll = inner.mute_btn_roll;
			mute_btn_muted = inner.mute_btn_muted;
			mute_btn_muted_roll = inner.mute_btn_muted_roll;
			
			
			mute_btn_roll.visible = mute_btn_muted.visible = mute_btn_muted_roll.visible = false;
			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, mute_mouse);
			this.addEventListener(MouseEvent.MOUSE_OUT, mute_mouse);
			this.addEventListener(MouseEvent.CLICK, mute_mouse);
		}
		
		public override function lateInit(e:Event):void{
			
		}
		
		protected override function onPlaybackEvent(e:ChromeEvent):void{
			switch(e.args.type){
				case "muted":
					setMute(e.args.value);
					break;
			}
		}
		
		private function setMute(m:Boolean):void{
			trace("ChromeMuteBtn.setMute("+m+")");
			if (m != muted){
				if (m){
					if (mute_btn_roll.visible){
						mute_btn_muted_roll.visible = true;
						mute_btn_muted.visible = false;
					} else {
						mute_btn_muted_roll.visible = false;
						mute_btn_muted.visible = true;
					}
					mute_btn.visible = false;
					mute_btn_roll.visible = false;
				} else {
					if (mute_btn_muted_roll.visible){
						mute_btn.visible = false;
						mute_btn_roll.visible = true;
					} else {
						mute_btn.visible = true;
						mute_btn_roll.visible = false;
					}
					mute_btn_muted.visible = false;
					mute_btn_muted_roll.visible = false;
				}
				muted = m;
			}
		}
		
		private function mute_mouse(e:MouseEvent):void{
			switch(e.type){
				case MouseEvent.CLICK:
					trace("mute_mouse click");
					if (muted){
						setMute(false);
						dispatchEvent(new ChromeEvent(ChromeEvent.CONTROLEVENT, { type: "mute", value: false } ));
					} else {
						setMute(true);
						dispatchEvent(new ChromeEvent(ChromeEvent.CONTROLEVENT, { type: "mute", value: true } ));
					}
					break;
				case MouseEvent.MOUSE_OVER:
					if (muted){
						mute_btn_muted_roll.visible = true;
						mute_btn_muted.visible = false;
					} else {
						mute_btn_roll.visible = true;
						mute_btn.visible = false;
					}
					break;
				case MouseEvent.MOUSE_OUT:
					if (muted){
						mute_btn_muted_roll.visible = false;
						mute_btn_muted.visible = true;
					} else {
						mute_btn_roll.visible = false;
						mute_btn.visible = true;
					}
					break;
			}
		}
		
	}
}