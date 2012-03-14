// com.dave.mediaplayers.YouTubePlayer
// Dave Cole
//
// This class is simply a wrapper around the chromeless YouTube AS3 player which handles its loading, events it can report,
// wraps identical function names to its API, and adds a few plain text state variables you can poll.
// Please note I modified the setVolume/getVolume calls to return a number normalized between 0 and 1 instead of 0 to 100.
//
// Ideally you would extend this class to include something with custom chrome.
//

package com.dave.mediaplayers {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	
	public class YouTubePlayer extends Sprite {
		// This will hold the API player instance once it is initialized.
		public var player:Object;
		public var bkgRect:Sprite;
		public var foreRect:Sprite;
		
		public var autoPlay:Boolean;			// If using the play() command, will autoplay.  Otherwise will not.
		public var desiredQuality:String;		// Desired playback quality when using the play() command.
		
		public var state:String; 				// Possible values: "unloaded", "unstarted", "ended", "playing", "paused", "buffering", "videocued", "unknown"
		public var qualityLevels:Array;
		public var quality:String; 				// Possible values: "small" "medium" "large" "hd720"
		public var highestQuality:String; 		// Possible values: "hd" or "hq"
		
		public var playerWidth:Number;
		public var playerHeight:Number;
		public var videoID:String;				// Currently cued video ID
		public var duration:Number;				// Currently cued video duration
		
		protected var wantToPlayNow:Boolean=false;
		
		protected var loader:Loader;
		
		
		public function YouTubePlayer(){
			videoID = "";
			autoPlay = true;
			playerWidth = 608;
			playerHeight = 342;
			state = "unloaded";
			desiredQuality = "default";
			
			bkgRect = drawRect(playerWidth,playerHeight,0x000000);
			addChild(bkgRect);
			
			foreRect = drawRect(playerWidth,playerHeight,0x000000);
			foreRect.alpha = 0;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3&nologo=1"));
		}
		
		//  The default size of the chromeless SWF when loaded into another SWF is 320px by 240px and the default size of the embedded player SWF is 480px by 385px. 
		public function setSize(w:Number,h:Number):void{
			trace("YouTubePlayer.setSize("+w+", "+h+")");
			playerWidth = w;
			playerHeight = h;
			bkgRect.width = foreRect.width = playerWidth;
			bkgRect.height = bkgRect.height = playerHeight;
			if (state != "unloaded"){
				player.setSize(w,h);
			}
		}
		
		
		
		// PLAYBACK FUNCTIONS
		
		// attempts to play the video at the highest quality, reference by either videoID or qualified URL to a youtube page.
		public function play(videoRef:String, info:Object=null):void{
			//player.visible = false;
			if (videoRef == videoID){
				// already cued video, so just play it.
				playVideo();
			} else {
				// load and (maybe) play video
				if (autoPlay){
					if (videoRef.indexOf("http://", 0) != -1){
						loadVideoByUrl(videoRef, 0);
					} else {
						loadVideoById(videoRef, 0, desiredQuality);
					}
				} else {
					if (videoRef.indexOf("http://", 0) != -1){
						cueVideoByUrl(videoRef, 0);
					} else {
						cueVideoById(videoRef, 0, desiredQuality);
					}
				}
			}
		}
		
		// stops and unloads video, closing the nestream.
		public function stop():void{
			stopVideo();
		}
		
		// Cues up a VideoID, loads its thumbnail, but does not play it.
		public function cueVideoById(_videoId:String, startSeconds:Number=0, suggestedQuality:String="default"):void {
			trace("YouTubePlayer.cueVideoById("+_videoId+")");
			videoID = _videoId;
			player.cueVideoById(_videoId, startSeconds, suggestedQuality);
		}
		
		// Loads a VideoID & thumbnail, and begins to play.
		public function loadVideoById(_videoId:String, startSeconds:Number=0, suggestedQuality:String="default"):void{
			trace("YouTubePlayer.loadVideoById("+_videoId+")");
			videoID = _videoId;
			wantToPlayNow = true;
			player.loadVideoById(_videoId, startSeconds, suggestedQuality);
			
		}
		
		// Cues up a fully qualified URL to a youtube video page, loads the thumbnail, but does not play it.
		public function cueVideoByUrl(mediaContentUrl:String, startSeconds:Number=0):void{
			videoID = mediaContentUrl.substr(mediaContentUrl.indexOf("/v/", 0) + 3, mediaContentUrl.length);
			player.cueVideoByUrl(mediaContentUrl, startSeconds);
		}
		
		// Loads a fully qualified URL to a youtube video page, loads the thumbnail, and plays it.
		public function loadVideoByUrl(mediaContentUrl:String, startSeconds:Number=0):void{
			videoID = mediaContentUrl.substr(mediaContentUrl.indexOf("/v/", 0) + 3, mediaContentUrl.length);
			player.loadVideoByUrl(mediaContentUrl, startSeconds);
		}
		
		
		// Plays the currently cued/loaded video. 
		public function playVideo():void{
			player.playVideo();
		}
		
		// Pauses the currently playing video. 
		public function pauseVideo():void{
			player.pauseVideo();
		}
		
		// Unpauses the currently playing video. 
		public function unpauseVideo():void{
			player.playVideo();
		}
		
		// Stops the current video. This function also closes the NetStream object and cancels the loading of the video. Once stopVideo() is called, a video cannot be resumed without reloading the player or loading a new video (chromeless player only). When calling stopVideo(), the player broadcasts an end event (0). 
		public function stopVideo():void{
			player.stopVideo();
			clearVideo();
			videoID = "";
		}
		
		// Seeks to the specified time of the video in seconds. The allowSeekAhead determines whether or not the player will make a new request to the server if seconds is beyond the currently loaded video data. Note that seekTo() will look for the closest keyframe before the seconds specified. This means that sometimes the play head may seek to just before the requested time, usually no more than ~2 seconds. 
		public function seekTo(seconds:Number, allowSeekAhead:Boolean):void{
			player.seekTo(seconds, allowSeekAhead);
		}
		
		// Clears the video display. This function is useful if you want to clear the video remnant after calling stopVideo(). Note that this function has been deprecated in the ActionScript 3.0 Player API. 
		public function clearVideo():void{
			player.clearVideo();
		}
		
		
		
		// VIDEO META DATA FUNCTIONS
		
		// Returns the duration in seconds of the currently playing video. Note that getDuration() will return 0 until the video's metadata is loaded, which normally happens just after the video starts playing. 
		public function getDuration():Number{
			
			if (state != "unloaded"){
				duration = player.getDuration();
				trace("YouTubePlayer.getDuration() == "+duration);
				if (!isNaN(duration) && duration != 0){
					trace("FOUND DURATION: "+duration);
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
		
		// Returns the YouTube.com URL for the currently loaded/playing video. 
		public function getVideoUrl():String{
			return(player.getVideoUrl());
		}
		
		// Returns the embed code for the currently loaded/playing video.
		public function getVideoEmbedCode():String{
			return(player.getVideoEmbedCode());
		}
		
		
		
		// SOUND FUNCTIONS
		
		// Mutes the player. 
		public function mute():void{
			player.mute();
		}
		
		// Unmutes the player. 
		public function unMute():void{
			player.unMute();
		}
		
		// Returns true if the player is muted, false if not. 
		public function isMuted():Boolean{
			return(player.isMuted());
		}
		
		// Sets the volume. Accepts an integer between 0 and 1 
		public function setVolume(vol:Number):void{
			player.setVolume(Math.round(vol * 100)); 
		}
		
		// Gets the volume, 0 to 1
		public function getVolume():Number{
			return(player.getVolume()/100);
		}
		
		
		// -----
		
		
		// Returns the number of bytes loaded for the current video. 
		public function getVideoBytesLoaded():Number{
			return(player.getVideoBytesLoaded());
		}
		
		// Returns the size in bytes of the currently loaded/playing video. 
		public function getVideoBytesTotal():Number{
			return(player.getVideoBytesTotal());
		}
		
		//Returns the number of bytes the video file started loading from. Example scenario: the user seeks ahead to a point that hasn't loaded yet, and the player makes a new request to play a segment of the video that hasn't loaded yet.
		public function getVideoStartBytes():Number{
			return(player.getVideoStartBytes());
		}
 		
		// Returns the elapsed time in seconds since the video started playing.
		public function getCurrentTime():Number{
			return(player.getCurrentTime());
		}
		
		// Returns the state of the player. Possible values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5). 
		// can also poll the variable "state" to get a plain text description
		public function getPlayerState():Number{
			var s:Number = player.getPlayerState();
			switch(s){
				case -1:
					state = "unstarted";
					break;
				case 0:
					state = "ended";
					break;
				case 1:
					
					state = "playing";
					break;
				case 2:
					state = "paused";
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
			return(s);
		}
		
		
		
		// EVENTS
		protected function onLoaderInit(event:Event):void {
			addChild(loader);
			loader.content.addEventListener("onReady", onPlayerReady);
			loader.content.addEventListener("onError", onPlayerError);
			loader.content.addEventListener("onStateChange", onPlayerStateChange);
			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);
			
			addChild(foreRect);
		}
		
		
		protected function onPlayerReady(event:Event):void {
			// Event.data contains the event parameter, which is the Player API ID
			trace("YouTubePlayer.onPlayerReady:", Object(event).data);
		
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			player = loader.content;
			setSize(playerWidth,playerHeight);
			state = "unstarted";
			
			dispatchEvent(event);
		}
		
		
		// The possible error codes are 100, 101, and 150.
		// 100: The video requested is not found. This occurs when a video has been removed (for any reason), or it has been marked as private. 
		// 101/150: The video requested does not allow playback in the embedded players. The error code 150 is the same as 101.
		protected function onPlayerError(event:Event):void {
			// Event.data contains the event parameter, which is the error code
			trace("YouTubePlayer.onPlayerError:" + Object(event).data + " - " (Object(event).data == 100 ? "Video Not Found" : "Video playback not allowed in embedded players."));
			
			dispatchEvent(event);
		}
		
		
		// "unloaded", "unstarted", "ended", "playing", "paused", "buffering", "videocued"
		// Possible values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5). 
		protected function onPlayerStateChange(event:Event):void {
			
			// Event.data contains the event parameter, which is the new player state
			switch(Object(event).data){
				case -1:
					state = "unstarted";
					break;
				case 0:
					state = "ended";
					break;
				case 1:
					state = "playing";
					setTimeout(getDuration, 500);
					break;
				case 2:
					state = "paused";
					break;
				case 3:
					state = "buffering";
					break;
				case 5:
					state = "videocued";
					determineHighestQuality();
					break;
				default:
					state = "unknown";
					break;
			}
			trace("YouTubePlayer.onPlayerStateChange: " + Object(event).data + " - " + state + "  videoID: "+videoID);
			
			dispatchEvent(event);
		}
		
		
		protected function onVideoPlaybackQualityChange(event:Event):void {
			// Event.data contains the event parameter, which is the new video quality
			trace("YouTubePlayer.onPlayerQualityChange", Object(event).data);
			quality = Object(event).data;
			
			dispatchEvent(event);
		}
		
		
		
		
		
		// UTILITY ROUTINES
		
		// This function retrieves the actual video quality of the current video. It returns undefined if there is no current video. Possible return values are hd720, large, medium and small. 
		public function getPlaybackQuality():String{
			quality = player.getPlaybackQuality();
			return(player.getPlaybackQuality());
		}
		
		// This function sets the suggested video quality for the current video. The function causes the video to reload at its current position in the new quality. If the playback quality does change, it will only change for the video being played.
		// The suggestedQuality parameter value can be "small", "medium", "large", "hd720" or "default". Setting the parameter value to default instructs YouTube to select the most appropriate playback quality, which will vary for different users, videos, systems and other playback conditions.
		public function setPlaybackQuality(suggestedQuality:String):void{
			player.setPlaybackQuality(suggestedQuality);
		}
		
		// returns hd or hq
		public function determineHighestQuality():String{
			qualityLevels = player.getAvailableQualityLevels()
			// qualityLevels may be undefined if the API function does not exist, 
			// in which case this conditional is false
			if (qualityLevels.length > 1) {
			
				var highestQuality:String = qualityLevels[0]
				if (highestQuality.indexOf("hd",0) != -1) {
					// Brand quality toggle button as HD.
					highestQuality = "hd";
				} else {
					// Brand quality toggle button as HQ.
					// The highest available quality is shown, but it is not HD video.
					highestQuality = "hq";
				}
			
				quality = player.getPlaybackQuality();
				if (quality == 'small' || quality == 'medium') {
					// The user is not watching the highest quality available 
					// can can toggle to a higher quality.
					brandQualityButton(highestQuality,false);
				} else {
					// The user is watching the highest quality available 
					// and can toggle to a lower quality.
					brandQualityButton(highestQuality,true);
				}
			
			} else {
				// Hide the toggle button because there is no current video or
				// there is only one quality available.
				quality = getPlaybackQuality();
				highestQuality = "hq";
				brandQualityButton("none",false);
			}
			return(highestQuality);
		}
		
		// *** override when skinning with custom chrome.
		// qualityType=="hd" when HD is available, qualityType=="hq" when HQ is available, qualityType=="none" when button should be hidden
		// hilighted==true when button should be hilighted, and false when it should be deselected.
		protected function brandQualityButton(qualityType:String, hilighted:Boolean=false):void{
			
		}
		
		private function drawRect(w:Number, h:Number, c:Number=0xFF0000):Sprite{
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(-1,c);
			s.graphics.beginFill(c);
			s.graphics.drawRect(0,0,w,h);
			s.graphics.endFill();
			return(s);
		}
		
		public function show():void{
			this.visible = true;
		}
		
		public function hide():void{
			this.visible = false;
		}
		
		public function destroy():void{
			player.destroy();
			loader.content.removeEventListener("onReady", onPlayerReady);
			loader.content.removeEventListener("onError", onPlayerError);
			loader.content.removeEventListener("onStateChange", onPlayerStateChange);
			loader.content.removeEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
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