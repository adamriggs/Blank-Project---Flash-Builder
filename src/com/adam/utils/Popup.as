// com.app.Popup
// Adam Riggs
//
package com.adam.utils {
	import flash.display.Sprite;
	import flash.events.*;
	
	import gs.TweenMax;
	
	import com.adam.utils.AppData;
	import com.adam.events.MuleEvent;
	
	public class Popup extends Sprite {
		
		private var appData:AppData=AppData.instance;
		
		private var tweenTime:Number;
		
		public var popupName:String;
		
		public function Popup(){
			
			init();
		}
		
//*****Initialization Routines
		
		public function init(){
			visible = false;
			trace("Popup() init");
			
			tweenTime=.1;
			initEvents();
		}
		
		public function initEvents():void{
			appData.eventManager.listen("popupCheck", onPopupCheck);
		}
		
//*****Core Functionality
		
		
		
//*****Event Handlers
		
		protected function onPopup(e:MuleEvent):void{
			switch(e.data.type){
				
				case "show":
					show();
				break;
				
				case "hide":
					hide();
				break;
				
				case "flip":
					flip();
				break;
				
			}
			
			appData.eventManager.dispatch("popupCheck",{activeName:popupName});
		}
		
		protected function onPopupCheck(e:MuleEvent):void{
			if(e.data.activeName!=popupName){hide();}
		}
		
//*****Gets and Sets
		
		
		
//*****Utility Functions
		
		public function show(){
			//this.visible = true;
			visible=true;
			TweenMax.to(this,tweenTime,{alpha:1});
		}
		
		public function hide(){
			//this.visible = false;
			TweenMax.to(this,tweenTime,{alpha:0,onComplete:visibleFalse});
		}
		
		public function flip():void{
			if(visible){hide();}else{show();}
		}
		
		private function visibleFalse():void{
			visible=false;
		}
		
		private function visibleTrue():void{
			visible=true;
		}
	
	}
}