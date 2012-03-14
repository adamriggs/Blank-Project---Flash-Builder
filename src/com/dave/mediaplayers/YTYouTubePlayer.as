// com.app.YTYouTubePlayer
// Dave Cole
//
package com.dave.mediaplayers {
	import caurina.transitions.*;
	
	import com.app.Application;
	import com.dave.events.*;
	import com.dave.mediaplayers.ChromeYouTubePlayer;
	import com.dave.mediaplayers.chrome.*;
	import com.dave.mediaplayers.chrome.events.*;
	import com.greensock.TweenMax;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	
	public class YTYouTubePlayer extends ChromeYouTubePlayer {
		private var dt:Date;
		public var strikeAgain:Number;
		
		private var bkg:MovieClip;
		private var cc:ChromeCollection;
		
	public function YTYouTubePlayer(){
			super();
			
			foreRect.addEventListener(MouseEvent.MOUSE_OVER, my_mouse);
			foreRect.addEventListener(MouseEvent.MOUSE_OUT, my_mouse);
			
			EventCenter.subscribe("onCopyEmbed", onCopyEmbed);
			EventCenter.subscribe("onPauseVideo", onPauseVideo);
			
		}
		
		protected override function initChrome():void{
			// add TBUC Chrome
			trace("YTYouTubePlayer.initChrome()");
			//bkg = new PlayerControlsBkg();
			//addChild(bkg);
			
			cc = new ChromeCollection({ parent: this, topPadding: -25 });
			
			cc.addChrome(new ChromePlayPauseBtn({ parent: this, leftPadding: 0 }));
			cc.addChrome(new ChromeEndCapLeft({ parent: this }));
			
			cc.addChrome(new ChromeScrubber({ parent: this, leftPadding: 0, topPadding: 0 }));
			
			//cc.addChrome(new ChromeTimeCounter({ parent: this }));
			//cc.addChrome(new ChromeEmbedBtn({ parent: this, leftPadding: 0 }));
			cc.addChrome(new ChromeEndCapRight({ parent: this, leftPadding: 0, rightPadding: 0 }));
			cc.addChrome(new ChromeMuteBtn({ parent: this, leftPadding: 0, rightPadding: 0 }));
			cc.addChrome(new ChromeQualityBtn({ parent: this }));
			//cc.addChrome(new ChromeFullScreenBtn({ parent: this, leftPadding: 0 }));
			
			//cc.addChrome(new ChromeAsset({ parent: this, asset:"ChromeStandin" }));
			
			//cc.addEventListener(MouseEvent.MOUSE_OUT, my_mouse);
			
			addChrome(cc,false);
			//cc.visible = false;
			cc.alpha = 0;
		}
		
		private function my_mouse(e:MouseEvent):void{
			switch(e.type){
				case MouseEvent.MOUSE_OVER:
					TweenMax.to(cc, 0.4, { alpha: 1 });
					break;
				case MouseEvent.MOUSE_OUT:
					if (cc.hitTestPoint(stage.mouseX, stage.mouseY) == false){
						TweenMax.to(cc, 0.4, { alpha: 0 });
					}
					break;
			}
		}
		
		private function onCopyEmbed(e:ApplicationEvent):void{
			System.setClipboard(getVideoEmbedCode());
		}
		
		public function resize(w:Number,h:Number):void{
			
			/*
			if (stage){
				trace("YTYouTubePlayer.resize("+w+", "+h+") "+stage.displayState);
				if (stage.displayState == StageDisplayState.NORMAL || stage.displayState == null){
					setSize(w,h);
					//bkg.y = h;
					//bkg.width = w;
					cc.setSize(w,h);
					
					
				} else {
					setSize(stage.stageWidth, stage.stageHeight - 25);
					//bkg.y = stage.stageHeight - 25;
					//bkg.width = stage.stageWidth;
					cc.setSize(stage.stageWidth, stage.stageHeight - 25);
					
				}
			} else {
				trace("YTYouTubePlayer.resize("+w+", "+h+") ");
				setSize(w,h);
				//bkg.y = h;
				//bkg.width = w;
				cc.setSize(w,h);
			}
			*/
			
			setSize(w,h);
			cc.setSize(w,h);
		}
		
		// --- override functions
		
		protected override function triggerFullScreen(bool:Boolean):void{
			// override this function to stretch the video & controls full screen and back
			
			//Application.shell.resizeHandler();
		}
		
		public override function play(videoRef:String, info:Object=null):void{
			trace("YTYouTubePlayer.play("+videoRef+") lastVideoID:"+videoID);
				addChild(cc);
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
		
		public override function stop():void{
			stopVideo();
		}
		
		protected override function onPlayerReady(event:Event):void {
			// Event.data contains the event parameter, which is the Player API ID
			trace("YouTubePlayer.onPlayerReady:", Object(event).data);
		
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			player = loader.content;
			state = "unstarted";
			
			dispatchEvent(new Event("YouTubePlayerEventReady"));
		}
		
		
		// The possible error codes are 100, 101, and 150.
		// 100: The video requested is not found. This occurs when a video has been removed (for any reason), or it has been marked as private. 
		// 101/150: The video requested does not allow playback in the embedded players. The error code 150 is the same as 101.
		protected override function onPlayerError(event:Event):void {
			// Event.data contains the event parameter, which is the error code
			trace("YouTubePlayer.onPlayerError:" + Object(event).data + " - "+ ((Object(event).data == 100) ? "Video Not Found" : "Video playback not allowed in embedded players."));
			
			dispatchEvent(event);
		}
		
		
		// "unloaded", "unstarted", "ended", "playing", "paused", "buffering", "videocued"
		// Possible values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5). 
		protected override function onPlayerStateChange(event:Event):void {
			
			// Event.data contains the event parameter, which is the new player state
			switch(Object(event).data){
				case -1:
					state = "unstarted";
					break;
				case 0:
					state = "ended";
					dispatchEvent(new Event("YouTubePlayerEventEnded"));
					break;
				case 1:
					state = "playing";
					//EventCenter.broadcast("onResize", { width: stage.stageWidth, height: stage.stageHeight });
					wantToPlayNow = false;
					if (this.visible){
						
						setTimeout(getDuration, 500);
					} else {
						stop();
					}
					break;
				case 2:
					if (wantToPlayNow){
						var pq:String = getPlaybackQuality();
						trace("plabackquality=="+pq);
						
						if (highestQuality == "hd"){
							if (pq != "hd720"){
								setTimeout(function():void{ setPlaybackQuality("hd720"); }, 500);
							} else {
								setTimeout(function():void{ setPlaybackQuality("large"); }, 500);
							}
						} else {
							if (pq != "large"){
								setTimeout(function():void{ setPlaybackQuality("large"); }, 500);
							} else {
								setTimeout(function():void{ setPlaybackQuality("medium"); }, 500);
							}
						}
						
						/*
						if (pq == "default"){
							if (highestQuality == "hd"){
								setTimeout(function(){ setPlaybackQuality("hd720"); }, 500);
							} else {
								setTimeout(function(){ setPlaybackQuality("large"); }, 500);
							}
						} else {
							
							setTimeout(function(){ setPlaybackQuality("default"); }, 500);
						}
						*/
						
						wantToPlayNow = false;
					}
					state = "paused";
					break;
				case 3:
					state = "buffering";
					player.visible = true;
					dispatchEvent(new Event("YouTubePlayerEventBuffering"));
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
			
			//dispatchEvent(event);
		}
		
		
		protected override function onVideoPlaybackQualityChange(event:Event):void {
			// Event.data contains the event parameter, which is the new video quality
			trace("YouTubePlayer.onPlayerQualityChange", Object(event).data);
			quality = Object(event).data;
			
			dispatchEvent(event);
		}
	
		
		private function onPauseVideo(e:ApplicationEvent):void{
			if (state == "playing"){
				pauseVideo();
			}
		}
	
	}
}