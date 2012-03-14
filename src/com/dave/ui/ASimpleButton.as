package com.dave.ui
{
	
	import flash.events.Event;
	import com.dave.interfaces.IDestroyable;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.utils.Dictionary;
	
	public class ASimpleButton extends SimpleButton implements IDestroyable
	{
		protected var _listeners:Dictionary;
		protected var _isDestroyed:Boolean=false;
		
		
		public function ASimpleButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			_listeners = new Dictionary();
			this.tabEnabled=false;
			this.addEventListener(Event.ADDED_TO_STAGE, _addedToStage);
			
		}
		
		/**
		 * Starts the component and calls a public init method which could be overwritten
		 * 
		 * 
		 * @param e - The Event from added to stage. 
		 * 
		 */		
		private function _addedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, _addedToStage);
			init();
		}
		
		/**
		 * An init() function for Subclass to overwrite when need initialization after getting added to stage. 
		 * 
		 */		
		public function init():void {
			
		}
		
		/**
		 * addEventLisetener override to  add the listener to a Vector list that will be destroyed up calling the destroy method 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_listeners[type] = listener;
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
			delete _listeners[type];
		}
		
		
		/**
		 * utility method to easily remove all event listeners without actually destroying the clip 
		 * 
		 */		
		public function removeAllListeners():void
		{
			for (var type:String in _listeners) {
				this.removeEventListener(type, _listeners[type]);
				delete _listeners[type];
			}
		}
		
		/**
		 *  
		 * @return isDestroyed Boolean 
		 * 
		 */		
		public function get isDestroyed():Boolean
		{
			return this._isDestroyed;
		}
		
		/**
		 * Destroy method for this DisplayObject 
		 * 
		 */			
		public function destroy():void
		{
			for (var type:String in _listeners) {
				this.removeEventListener(type, _listeners[type]);
				delete _listeners[type];
			}
			_listeners = null;
			
			
			this.downState=null;
			this.upState=null;
			this.hitTestState=null;
			this.overState=null;
			
			
			if (this.parent != null)
				this.parent.removeChild(this);
			
			this._isDestroyed = true;
			
		}
		
	}
}