// com.dave.mediaplayers.ChromeYouTubePlayer
// Dave Cole
//
package com.dave.mediaplayers {
	import com.dave.mediaplayers.YouTubePlayer;
	import com.dave.mediaplayers.chrome.*;
	import com.dave.mediaplayers.chrome.events.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.*;
	import flash.system.System;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class ChromeYouTubePlayer extends YouTubePlayer {
		protected var chrome:Array;
		protected var i:int;
		
		private var scrubberTimer:Timer;
		private var loaderTimer:Timer;
		
		public function ChromeYouTubePlayer(){
			super();
			chrome = new Array();
			
			scrubberTimer = new Timer(500);
			scrubberTimer.addEventListener(TimerEvent.TIMER, scrubberTimerHandler);
			
			loaderTimer = new Timer(500);
			loaderTimer.addEventListener(TimerEvent.TIMER, loaderTimerHandler);
			
			trace("ChromeYouTubePlayer.initChrome()");
			initChrome();
		}
		
		protected function initChrome():void{
			// *** EXTEND THIS CLASS AND OVERRIDE THIS FUNCTION TO ADD ANY CHROME YOU LIKE
			
		}
		
		protected function addChrome(c:Chrome, under:Boolean=false):void{
			if (under){
				addChildAt(c,0);
			} else {
				addChild(c);
			}
			c.addEventListener(ChromeEvent.CONTROLEVENT, onControlEvent);
			chrome.push(c);
		}
		
		protected function removeChrome(c:Chrome):void{
			for(i=0; i < chrome.length; i++){
				if (chrome[i] == c){
					chrome[i].destroy(); // destroy removes the child
					chrome[i] = null;
					chrome.splice(i, 1);
				}
			}
		}
		
		protected function removeAllChrome():void{
			for (i=0; i < chrome.length; i++){
				chrome[i].destroy(); // destroy removes the child
				chrome[i] = null;
			}
			chrome = new Array();
		}
		
		protected function onControlEvent(e:ChromeEvent):void{
			if (state != "unloaded"){
				switch(e.args.type){
					case "play":
						playVideo();
						break;
					case "pause":
						pauseVideo();
						break;
					case "rewind":
						seekTo(0,true);
						break;
					case "stop":
						stopVideo();
						break;
					case "next":
						// not applicable
						break;
					case "seek":
						if (duration != 0){
							seekTo(e.args.value * duration, true);
						}
						break;
					case "fullscreen":
						if (stage){
							if (stage.displayState == null){
								stage.displayState = StageDisplayState.NORMAL;
							}
							if (e.args.value == null){
								// toggle
								if (stage.displayState == StageDisplayState.NORMAL){
									stage.displayState = StageDisplayState.FULL_SCREEN;
									triggerFullScreen(true);
								} else {
									stage.displayState = StageDisplayState.NORMAL;
									triggerFullScreen(false);
								}
							} else {
								if (e.args.value == true){
									if (stage.displayState == StageDisplayState.NORMAL){
										stage.displayState = StageDisplayState.FULL_SCREEN;
										triggerFullScreen(true);
									}
								} else {
									if (stage.displayState == StageDisplayState.FULL_SCREEN){
										stage.displayState = StageDisplayState.NORMAL;
										triggerFullScreen(false);
									}
								}
							}
						}
						
						break;
					case "embed":
						// do embed code
						System.setClipboard(getVideoEmbedCode());
						
						break;
					case "volume":
						setVolume(e.args.value);
						break;
					case "mute":
						if (e.args.value == true){
							// mute media
							mute();
						} else {
							// unmute media
							unMute();
						}
						break;
					case "quality":
						setPlaybackQuality(e.args.value);
						break;
					case "updatesize":
						updateSize();
				}
			}
		}
		
		protected function triggerFullScreen(bool:Boolean):void{
			// override this function to stretch the video & controls full screen and back
			
		}
		
		
		// --- override functions
		
				// Cues up a VideoID, loads its thumbnail, but does not play it.
		public override function cueVideoById(_videoId:String, startSeconds:Number=0, suggestedQuality:String="default"):void {
			trace("ChromeYouTubePlayer.cueVideoById("+_videoId+")");
			videoID = _videoId;
			player.cueVideoById(_videoId, startSeconds, suggestedQuality);
			loaderTimer.start();
		}
		
		// Loads a VideoID & thumbnail, and begins to play.
		public override function loadVideoById(_videoId:String, startSeconds:Number=0, suggestedQuality:String="default"):void{
			trace("ChromeYouTubePlayer.loadVideoById("+_videoId+")");
			videoID = _videoId;
			wantToPlayNow = true;
			player.loadVideoById(_videoId, startSeconds, suggestedQuality);
			loaderTimer.start();
			
		}
		
		// Cues up a fully qualified URL to a youtube video page, loads the thumbnail, but does not play it.
		public override function cueVideoByUrl(mediaContentUrl:String, startSeconds:Number=0):void{
			videoID = mediaContentUrl.substr(mediaContentUrl.indexOf("/v/", 0) + 3, mediaContentUrl.length);
			player.cueVideoByUrl(mediaContentUrl, startSeconds);
			loaderTimer.start();
		}
		
		// Loads a fully qualified URL to a youtube video page, loads the thumbnail, and plays it.
		public override function loadVideoByUrl(mediaContentUrl:String, startSeconds:Number=0):void{
			videoID = mediaContentUrl.substr(mediaContentUrl.indexOf("/v/", 0) + 3, mediaContentUrl.length);
			player.loadVideoByUrl(mediaContentUrl, startSeconds);
			loaderTimer.start();
		}
		
		protected override function onLoaderInit(event:Event):void {
			addChild(loader);
			loader.content.addEventListener("onReady", onPlayerReady);
			loader.content.addEventListener("onError", onPlayerError);
			loader.content.addEventListener("onStateChange", onPlayerStateChange);
			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);
			
			loader.content.addEventListener("onStateChange", onChromePlayerStateChange);
			loader.content.addEventListener("onPlaybackQualityChange", onChromePlaybackQualityChange);
			loader.content.addEventListener("onReady", onChromePlayerReady);
			
			addChild(foreRect);
		}
		
		//  The default size of the chromeless SWF when loaded into another SWF is 320px by 240px and the default size of the embedded player SWF is 480px by 385px. 
		public override function setSize(w:Number,h:Number):void{
			trace("ChromeYouTubePlayer.setSize("+w+", "+h+")");
			playerWidth = w;
			playerHeight = h;
			bkgRect.width = foreRect.width = playerWidth;
			bkgRect.height = bkgRect.height = playerHeight;
			if (state != "unloaded"){
				player.setSize(w,h);
			}
			
			// size chrome
			
		}
		
		public function updateSize():void{
			setSize(playerWidth,playerHeight);
		}
		
		protected function onChromePlayerReady(event:Event):void {
			// activate chrome
			
		}
		
		// "unloaded", "unstarted", "ended", "playing", "paused", "buffering", "videocued"
		// Possible values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5). 
		protected function onChromePlayerStateChange(event:Event):void {
			// This handler works in conjunction with the onPlayerStateChange handler and only manages chrome states.
			// Event.data contains the event parameter, which is the new player state
			switch(Object(event).data){
				case -1:
					state = "unstarted";
					dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "seek", value: 0 }));
					dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "paused" }));
					dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "unstarted" }));
					scrubberTimer.stop();
					break;
				case 0:
					state = "ended";
					dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "seek", value: 0 }));
					dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "paused" }));
					scrubberTimer.stop();
					break;
				case 1:
					state = "playing";
					dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "playing" }));
					scrubberTimer.start();
					break;
				case 2:
					state = "paused";
					dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "paused" }));
					scrubberTimer.stop();
					break;
				case 3:
					state = "buffering";
					
					break;
				case 5:
					state = "videocued";
					
					break;
				default:
					state = "unknown";
					break;
			}
			trace("ChromeYouTubePlayer.onChromePlayerStateChange: " + Object(event).data + " - " + state + "  videoID: "+videoID);
			
		}
		
		// Returns the duration in seconds of the currently playing video. Note that getDuration() will return 0 until the video's metadata is loaded, which normally happens just after the video starts playing. 
		public override function getDuration():Number{
			
			if (state != "unloaded"){
				duration = player.getDuration();
				trace("YouTubePlayer.getDuration() == "+duration);
				if (!isNaN(duration) && duration != 0){
					trace("FOUND DURATION: "+duration);
					dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "duration", duration: duration }));
				} else {
					duration = 0;
					if (state != "unstarted" && state != "unknown"){
						setTimeout(getDuration, 500);
					}
				}
				return(player.getDuration());
			} else {
				return(0);
			}
		}
		
		protected function onChromePlaybackQualityChange(event:Event):void {
			// Event.data contains the event parameter, which is the new video quality
			trace("YouTubePlayer.onPlayerQualityChange", Object(event).data);
			quality = Object(event).data;
			if (quality == "hd720" || quality == "large"){
				dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "quality", hilighted: true } ));
			} else {
				dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "quality", hilighted: false } ));
			}
			
			
			dispatchEvent(event);
		}
		
		// *** override when skinning with custom chrome.
		// qualityType=="hd" when HD is available, qualityType=="hq" when HQ is available, qualityType=="none" when button should be hidden
		// hilighted==true when button should be hilighted, and false when it should be deselected.
		protected override function brandQualityButton(qualityType:String, hilighted:Boolean=false):void{
			dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "qualitybrand", qualityType: qualityType, hilighted: hilighted } ));
		}
		
		
		private function scrubberTimerHandler(e:TimerEvent):void{
			if (state == "playing"){
				if (duration > 0){

					dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "headposition", value: getCurrentTime()/duration, time: getCurrentTime(), duration: duration } ));
				}
			} else {
				scrubberTimer.stop();
			}
		}
		
		private function loaderTimerHandler(e:TimerEvent):void{
			if (state != "unloaded"){
				var t:Number = getVideoBytesTotal();
				if (!isNaN(t) && t > 0){
					var l:Number = getVideoBytesLoaded();
					dispatchEvent(new ChromeEvent(ChromeEvent.PLAYBACKEVENT, { type: "loadprogress", value: l/t } ));
					if (l >= t){
						loaderTimer.stop();
					}
				} else {
					loaderTimer.stop(); // ** could prematurely stop timer?
				}
			} else {
				loaderTimer.stop();
			}
		}
		
		
		public override function destroy():void{
			player.destroy();
			removeAllChrome();
			
			loader.content.removeEventListener("onReady", onPlayerReady);
			loader.content.removeEventListener("onError", onPlayerError);
			loader.content.removeEventListener("onStateChange", onPlayerStateChange);
			loader.content.removeEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			
			loader.content.removeEventListener("onStateChange", onChromePlayerStateChange);
			loader.content.removeEventListener("onPlaybackQualityChange", onChromePlaybackQualityChange);
			loader.content.removeEventListener("onReady", onChromePlayerReady);
			
			try {
				loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);
			} catch (e:Error){}
			loader = null;
			player = null;
			qualityLevels = null;
			state = "unloaded";
		}
	
	}
}