package com.dave.ui
{
	import com.dave.interfaces.IDestroyable;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import org.osflash.signals.Signal;
	
	public class ASprite extends Sprite implements IDestroyable
	{
		protected var _listeners:Dictionary;
		protected var _isDestroyed:Boolean=false;
		
		/**
		 * ASprite
		 * An abstract Sprite class, that setups some real common defaults need to help in sites. 
		 * 
		 */		
		public function ASprite()
		{
			super();
			_listeners = new Dictionary();
			this.tabEnabled=false;
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
		 * Utility method to remove all listeners from the sprite 
		 * 
		 */		
		public function removeAllListeners():void
		{
			for (var type:String in _listeners)
			{
				this.removeEventListener(type, _listeners[type]);
				delete _listeners[type];
			}
		}
		
		/**
		 * Utility method to remove all signals from the sprite 
		 * 
		 */		
		public function removeAllSignals():void
		{
			var type:XML = describeType(this);
			
			var signalList:XMLList = type..variable.( /osflash\.signals.*Signal/.test(@type) );
			var len:int = signalList.length();
			var name:String;
			for (var i:int=0;i<len;i++) {
				name = signalList[i].@name;
				if (this[name]!=null)  Signal(name).removeAll();
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
			removeAllListeners();
			_listeners = null;
			
			removeAllSignals();
			
			
			while (this.numChildren>0) {
				var child:DisplayObject = this.getChildAt(0);
				if (child is IDestroyable) {
					IDestroyable(child).destroy();
				} else {
					removeChild(child);
				}
				child=null;
			}
			
			
			if (this.parent != null)
				this.parent.removeChild(this);
			
			this._isDestroyed = true;
		}
	}
}