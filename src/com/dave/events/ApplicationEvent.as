package com.dave.events {
	import flash.events.Event;
	
	public class ApplicationEvent extends flash.events.Event {

		public var args:Object;
	
		public function ApplicationEvent( type:String, args:Object ) {
			super(type);
			this.args = args;
		}
	}
}

