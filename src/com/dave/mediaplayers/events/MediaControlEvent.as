package com.dave.mediaplayers.events {
	import flash.events.Event;
	
	public class MediaControlEvent extends flash.events.Event {
		public static const PAUSE:String = "pause";
		public static const PLAY:String = "play";
		public static const REWIND:String = "rewind";
		public static const STOP:String = "stop";
		public static const NEXT:String = "next";
		public static const KILL:String = "kill";
		public static const SEEK:String = "seek";
		public static const SEEK_MOUSEUP:String = "seek_mouseup";
		public static const VOLUME:String = "volume";
		public static const MUTE:String = "mute";
		public var args:Object;
	
		public function MediaControlEvent( type, args ) {
			super(type);
			this.args = args;
		}
	}
}

