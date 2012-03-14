// com.adam.events.EventManager
// Adam Riggs
// 2/25/2011
//

package com.adam.events{
	
	import flash.events.EventDispatcher;
 	import flash.events.Event;
	import com.adam.events.MuleEvent;
	
	public class EventManager{
		
		protected var dispatcher:EventDispatcher;
		
		private static const _instance:EventManager=new EventManager(EventLock);
		
		public function EventManager(lock:Class){
			
			// Verify that the lock is the correct class reference.
			if ( lock != EventLock )
			{
				throw new Error( "Invalid EventManager access.  Use EventManager.instance instead." );
			}
			
			dispatcher = new EventDispatcher();
		}
		
		public function listen(type:String, listener:Function):void {
			dispatcher.addEventListener(type, listener);
		}
		
		public function stopListening(type:String, listener:Function):void {
			dispatcher.removeEventListener(type, listener);
		}
		
		public function dispatch(eventName:String, paramObj:Object):void {
			dispatcher.dispatchEvent(new MuleEvent(eventName, paramObj));
		}
		
		public static function get instance():EventManager
		{
			return _instance;
		}
	}
}

class EventLock{
}