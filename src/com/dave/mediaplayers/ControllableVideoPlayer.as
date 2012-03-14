// ControllableVideoPlayer.as
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
//
//
//  License: Only Dave Cole and active Mekanism employees or contractors may use this code.
//
// 
package com.dave.mediaplayers {
	import flash.display.MovieClip;
	import flash.net.NetConnection;
	import flash.events.*;
	import flash.utils.Timer;
	
	import com.dave.mediaplayers.SimpleVideoPlayer;
	import com.dave.mediaplayers.Controls;
	import com.dave.mediaplayers.events.*;
	
	public class ControllableVideoPlayer extends SimpleVideoPlayer {
		public var _scrubberReference:MovieClip;
		public var _timer:Timer;
		public var muted:Boolean;
		public var origVolume:Number;
		
		public function ControllableVideoPlayer(xPos:int, yPos:int, w:int, h:int, autoStart:Boolean, bufferTimeDuration:Number, globalNetConnection:NetConnection, parentObject:Object, origSize:Boolean=false, smoothing:Boolean=false, scrubberReference:Controls=null){
			trace("new ScrubberVideoPlayer("+xPos+", "+yPos+", "+w+", "+h+", "+autoStart+", "+bufferTimeDuration+", "+globalNetConnection+", "+parentObject+", "+origSize+", "+smoothing+", "+scrubberReference);
			super(xPos, yPos, w, h, autoStart, bufferTimeDuration, globalNetConnection, parentObject, origSize, smoothing);
			
			_scrubberReference = scrubberReference;
			initScrubber();
		}
		
		public function initScrubber(){
		
			_scrubberReference.addEventListener(MediaControlEvent.PLAY, playButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.PAUSE, pauseButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.REWIND, rewindButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.STOP, stopButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.VOLUME, volumeSet);
			_scrubberReference.addEventListener(MediaControlEvent.MUTE, muteSet);
												
			this.addEventListener(MediaPlaybackEvent.DURATION, _scrubberReference.durationReceived);
			this.addEventListener(MediaPlaybackEvent.PLAYING, _scrubberReference.mediaPlaying);
			this.addEventListener(MediaPlaybackEvent.PAUSED, _scrubberReference.mediaPaused);
			this.addEventListener(MediaPlaybackEvent.STOPPED, _scrubberReference.mediaStopped);
			
			origVolume = getVolume();
			muted = false;
		}
		
		
		
		// ---- Event Handlers --------------
		
		public function playButtonPressed(e:Event){
			unpauseVideo();
		}
		
		public function pauseButtonPressed(e:Event){
			pauseVideo();
		}
		
		public function rewindButtonPressed(e:Event){
			rewindVideo();
		}
		
		public function stopButtonPressed(e:Event){
			stopVideo();
			_timer.stop();
		}
		
		public function volumeSet(e:MediaControlEvent){
			trace("received volumeSet "+e.args.volumenum);
			setVolume(e.args.volumenum);
		}
		
		public function muteSet(e:MediaControlEvent){
			if (muted){
				muted = false;
				setVolume(origVolume);
			} else {
				muted = true;
				setVolume(0);
			}
		}
		
		// ------------------------------------
		
		public override function onMetaData(data:Object){
			trace("ScrubberVideoPlayer: "+_currentVideo+" duration: "+data.duration+" sec, orig size: "+_video.videoWidth+","+_video.videoHeight+", display size: "+_w+","+_h);
			_duration = data.duration;
			dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.DURATION, { duration: _duration }));
			
		}
	}
}