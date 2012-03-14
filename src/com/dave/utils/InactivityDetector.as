/**
 * InactivityDetector, Dave Cole
 */
package com.dave.utils {
    import flash.utils.Timer;
	import com.app.Application;
	import com.dave.events.*;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
    public class InactivityDetector extends Sprite {
        private var inactivityTimeout:Number;
		private var timer:Timer;
		public var enabled:Boolean;

        public function InactivityDetector(_inactivityTimeout:int) {
			inactivityTimeout = _inactivityTimeout;
			if (Application.stage != null){
				Application.stage.addEventListener(MouseEvent.CLICK, resetTimer);
				Application.stage.addEventListener(KeyboardEvent.KEY_DOWN, resetTimer);
				Application.stage.addEventListener(MouseEvent.MOUSE_MOVE, resetTimer);
			} else if (stage != null) {
				stage.addEventListener(MouseEvent.CLICK, resetTimer);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, resetTimer);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, resetTimer);
			}
			//Application.stage.addEventListener(MouseEvent.MOUSE_MOVE, resetTimer);
			_timer = new Timer(inactivityTimeout);
			_timer.addEventListener(TimerEvent.TIMER, spawnInactivityEvent);
			_timer.start();
			enabled = true;
        }
		
		public function lateInit():void{
			stage.addEventListener(MouseEvent.CLICK, resetTimer);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, resetTimer);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, resetTimer);
		}
		
		public function resetTimer(e:Event=null):void{
			_timer.reset();
			if (enabled){
				_timer.start();
			}
		}
		
		public function spawnInactivityEvent(e:Event=null):void{
			if (enabled){
				trace("inactivitiy event!");
				EventCenter.broadcast("onInactivity", { timeout: inactivityTimeout });
			}
		}

		public function disable():void{
			_timer.stop();
			enabled = false;
		}
		
		public function enable():void{
			_timer.start();
			enabled = true;
		}
		
        
    }
}