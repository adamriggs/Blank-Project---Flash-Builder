// com.adam.events.MuleEvent
// Adam Riggs
// 2/24/2011
//
// A custom event with an object for carrying data to and fro


package com.adam.events{
	
	import flash.events.Event;
	
	public class MuleEvent extends Event{
		
		public var data:Object;
		
		public function MuleEvent(type:String, d:Object=null, bubbles:Boolean=false, cancelable:Boolean=false):void{
			super(type, bubbles, cancelable);
			data=d;
		}
		
		public override function clone():Event{
			return new MuleEvent(type, data, bubbles, cancelable);
		}
		
		/*public override function toString():void{
			return formatToString("MuleEvent", "type", "data", "bubbles", "cancelable");
		}*/
		
	}
}