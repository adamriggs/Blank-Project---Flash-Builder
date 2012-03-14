 /**
 * EvenCenter is a central class that manages events.  It contains three static methods
 * which allow the subscription, broadcast, and unsubscription of events. 
 *
 * Adapted from Jason Cook's and Michael Christoff's AS2 EventCenter. 
 *
 * @class EventCenter
 * @author Dave Cole, Michael Christoff, Jason Cook
 * @version 0.3.0
 *
 * @history 0.1.0 (2006.12.04) Created initial version of EventCenter. - Jason Cook
 * @history 0.2.0 (2007.09.05) Made public static functions to make syntax more clear and concise - Michael Christoff
 * @history 0.3.0 (2007.11.26) Ported to AS3 - Dave Cole
 */

package com.dave.events {
	import flash.events.EventDispatcher;
 	import flash.events.Event;
	import com.dave.events.ApplicationEvent;
	
	public class EventCenter {
		protected static var disp:EventDispatcher;

		public function EventCenter() {
			if (disp == null) { disp = new EventDispatcher(); }
		}	
	
		public static function subscribe(type:String, listener:Function):void {
			if (disp == null) { disp = new EventDispatcher(); }
			disp.addEventListener(type, listener);
		}
		
		public static function unsubscribe(type:String, listener:Function):void {
			if (disp == null) { disp = new EventDispatcher(); }
			disp.removeEventListener(type, listener);
		}
		
		public static function broadcast(eventName:String, paramObj:Object):void {
			if (disp == null) { disp = new EventDispatcher(); }
			disp.dispatchEvent(new ApplicationEvent(eventName, paramObj));
		}

	}
}