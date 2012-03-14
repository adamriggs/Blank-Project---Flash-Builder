// com.adam.utils.AdamButton_GenericButton
// Adam Riggs
//
package com.adam.utils.buttons {
	
	import flash.display.MovieClip;
	import com.adam.utils.AdamButton;
	
	public class AdamButton_GenericButton extends AdamButton {
		
		public var outBtn,hoverBtn:MovieClip;
		
		public function AdamButton_GenericButton(){
			out_state=outBtn;
			hover_state=hoverBtn;
			initAdamButton_GenericButton();
		}
		
//*****Initialization Routines
		
		public function initAdamButton_GenericButton(){
			trace("AdamButton_GenericButton() init");
			
			hoverBtn.alpha=0;
			
		}
		
//*****Core Functionality
		
		
		
//*****Event Handlers
		
		
		
//*****Gets and Sets
		
		
		
//*****Utility Functions
		
		
	
	}
}