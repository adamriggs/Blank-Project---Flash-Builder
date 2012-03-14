// com.app.Popup_Generic
// Adam Riggs
//
package com.app {
	import flash.display.Sprite;
	import flash.events.*;
	
	import gs.TweenMax;
	
	import com.adam.utils.AppData;
	import com.adam.utils.Popup;
	import com.adam.events.MuleEvent;
	
	public class Popup_Generic extends Popup {
		
		private var appData:AppData=AppData.instance;
		
		public function Popup_Generic(){
			
			initPopup_Generic();
		}
		
//*****Initialization Routines
		
		public function initPopup_Generic(){
			//this.visible = false;
			trace("Popup_Generic() init");
			
			popupName="";	//fill this in
			appData.eventManager.listen(popupName, onPopup);
		}
		
		/*public override function initEvents():void{
		}*/
		
//*****Core Functionality
		
		
		
//*****Event Handlers
		
		
//*****Gets and Sets
		
		
		
//*****Utility Functions
		
	
	}
}