package com.dave.ui
{
	import com.dave.interfaces.IDestroyable;
	
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import org.osflash.signals.Signal;
	
	public dynamic class AMovieClip extends MovieClip implements IDestroyable
	{
		protected var _listeners:Dictionary;
		protected var _isDestroyed:Boolean=false;
		
		/**
		 * AMovieClip
		 * An abstract MovieClip class, that setups some real common defaults need to help in sites. 
		 * 
		 */		
		public function AMovieClip()
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
		 * Check to see if a MovieClip has a specific frame label
		 * @param value
		 * @return a Boolean value that indicates where the MovieClip has this frame 
		 * 
		 */		
		public function hasFrameLabel(value:String):Boolean
		{
			var bool:Boolean = false;
			var i:int, len:int = currentLabels.length;
			for (i=0;i<len;i++) {
				if (FrameLabel(currentLabels[i]).name==value) return true;
			}
			return bool;
		}
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public function getFrameLabel(value:String):FrameLabel
		{
			var frameLabel:FrameLabel = null;
			var i:int, len:int = currentLabels.length, fLabel:FrameLabel;
			for (i=0;i<len;i++) {
				fLabel = currentLabels[i];
				if (fLabel.name==value) return fLabel;
			}
			return frameLabel;
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