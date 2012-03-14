// com.adam.utils.AdamButton
// Adam Riggs
//
package com.adam.utils {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.*;
	
	//import caurina.transitions.*;
	import gs.TweenMax;
	
	import com.adam.utils.AppData;
	import com.adam.events.MuleEvent;
	
	public class AdamButton extends Sprite {
		
		public var transTime:Number=.1;
		public var transType:String="linear";
		
		public var hover_state, out_state:MovieClip;
		
		private var _eventName:String;
		private var _parameters:Object;
		
		private var appData:AppData=AppData.instance;
		
		public function AdamButton(){
			
			init();
		}
		
//*****Initialization Routines
		
		public function init(){
			//trace("AdamButton() init");
			//appData.eventManager.listen("button", onAdamButton);
			
			useHandCursor=true;
			buttonMode=true;
			
			enable();
			initHoverStates();
		}
		
		private function initHoverStates():void{
			addHoverStates();
		}
		
//*****Core Functionality
		
		public function addHoverStates():void{
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		public function removeHoverStates():void{
			removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		public function disable():void{
			//removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			removeEventListener(MouseEvent.MOUSE_UP, onUp);
			//removeEventListener(MouseEvent.CLICK, onDown);
		}
		
		public function enable():void{
			//addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addEventListener(MouseEvent.MOUSE_UP, onUp);
			//addEventListener(MouseEvent.CLICK, onDown);
		}
		
		public function setAction(eName:String, params:Object):void{
			_eventName=eName;
			_parameters=params;
			
		}
		
		public function action():void{
			appData.eventManager.dispatch(_eventName, _parameters);
		}
		
//*****Event Handlers
		
		public function onDown(e:Event):void{
			
		}
		
		public function onUp(e:Event):void{
			action();
		}
		
		public function onOver(e:Event):void{
			//trace("over");
			/*Tweener.addTween(hover_state, {alpha:1, time:transTime, transition:transType});
			Tweener.addTween(out_state, {alpha:0, time:transTime, transition:transType});*/
			
			TweenMax.to(hover_state, transTime, {alpha:1});
			TweenMax.to(out_state, transTime, {alpha:0});
		}
		
		public function onOut(e:Event):void{
			/*Tweener.addTween(hover_state, {alpha:0, time:transTime, transition:transType});
			Tweener.addTween(out_state, {alpha:1, time:transTime, transition:transType});*/
			
			TweenMax.to(hover_state, transTime, {alpha:0});
			TweenMax.to(out_state, transTime, {alpha:1});
		}
		
		public function onAdamButton(e:MuleEvent):void{
			//trace("AdamButton e.data.type=="+e.data.type);
			switch(e.data.type){
				case "enable":
					enable();
				break;
				
				case "disable":
					disable();
				break;
			}
		}
		
//*****Gets and Sets
		
		public function get eventName():String{return _eventName;}
		public function set eventName(value:String):void{_eventName=value;}
		
		public function get parameters():Object{return _parameters;}
		public function set parameters(value:Object):void{_parameters=value;}
		
//*****Utility Functions
		
		public function show(){
			this.visible = true;
		}
		
		public function hide(){
			this.visible = false;
		}
		
	
	}
}