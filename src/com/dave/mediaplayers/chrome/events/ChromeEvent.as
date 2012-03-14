package com.dave.mediaplayers.chrome.events {
	import flash.events.Event;
	
	public class ChromeEvent extends flash.events.Event {
		public static const PLAYBACKEVENT:String = "playbackevent";
		// playback events can be of args.type "playing", "paused", "stopped", "doneplaying", "bufering", "cuepoint", "duration", "headposition" (args of value: 0-1), "loadprogress" (args of value: 0-1)
		
		public static const CONTROLEVENT:String = "controlevent";
		// control events can be of args.type "play", "pause", "rewind", "stop", "next", "seek" (args of value: 0-1), "volume" (args of value: 0-1), "embed", "mute" (args of value: true or false), "fullscreen" (optional args of value: true or false)
		
		
		public var args:Object;
		
		public function ChromeEvent( type, args ) {
			super(type);
			this.args = args;
		}
		
	}
}

