package com.dave.mediaplayers.events {
	import flash.events.Event;
	
	public class MediaPlaybackEvent extends flash.events.Event {
		public static const LOADING:String = "loading";
		public static const PLAYING:String = "playing";
		public static const PAUSED:String = "paused";
		public static const STOPPED:String = "stopped";
		public static const DONEPLAYING:String = "doneplaying";
		public static const REBUFFERING:String = "rebuffering";
		public static const DONEREBUFFERING:String = "donerebuffering";
		public static const CUEPOINT:String = "cuepoint";
		public static const DURATION:String = "duration";
		public static const HEADPOSITION:String = "headposition";
		public static const LOADPROGRESS:String = "loadprogress";
		public var args:Object;
	
		public function MediaPlaybackEvent( type, args ) {
			super(type);
			this.args = args;
		}
	}
}

