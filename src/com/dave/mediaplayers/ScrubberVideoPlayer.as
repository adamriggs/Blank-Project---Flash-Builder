// ScrubberVideoPlayer.as
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
	import com.dave.mediaplayers.Scrubber;
	import com.dave.mediaplayers.events.*;
	
	public class ScrubberVideoPlayer extends SimpleVideoPlayer {
		public var _scrubberReference:MovieClip;
		public var _timer:Timer;
		
		public function ScrubberVideoPlayer(xPos:int, yPos:int, w:int, h:int, autoStart:Boolean, bufferTimeDuration:Number, globalNetConnection:NetConnection, parentObject:Object, scrubberReference:Scrubber){
			trace("new ScrubberVideoPlayer("+xPos+", "+yPos+", "+w+", "+h+", "+autoStart+", "+bufferTimeDuration+", "+globalNetConnection+", "+parentObject+", "+scrubberReference);
			super(xPos, yPos, w, h, autoStart, bufferTimeDuration, globalNetConnection, parentObject, false);
			
			_scrubberReference = scrubberReference;
			initScrubber();
		}
		
		public function initScrubber(){
			_scrubberReference.x = _x;
			_scrubberReference.y = _y + _h;
			addChild(_scrubberReference);
		
			_scrubberReference.addEventListener(MediaControlEvent.PLAY, playButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.PAUSE, pauseButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.REWIND, rewindButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.STOP, stopButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.SEEK, scrubberSeek);
			_scrubberReference.addEventListener(MediaControlEvent.VOLUME, volumeSet);
			
			this.addEventListener(MediaPlaybackEvent.PLAYING, _scrubberReference.mediaPlaying);
			this.addEventListener(MediaPlaybackEvent.PAUSED, _scrubberReference.mediaPaused);
			this.addEventListener(MediaPlaybackEvent.STOPPED, _scrubberReference.mediaStopped);
			this.addEventListener(MediaPlaybackEvent.DURATION, _scrubberReference.durationReceived);
			this.addEventListener(MediaPlaybackEvent.HEADPOSITION, _scrubberReference.mediaSeekUpdate);
			this.addEventListener(MediaPlaybackEvent.STOPPED, mediaStopped);
			this.addEventListener(MediaPlaybackEvent.LOADPROGRESS, _scrubberReference.loadProgress);
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
		
		public function scrubberSeek(e:MediaControlEvent){
			seekTo(e.args.time);
		}
			
		public function sendHeadPositionEvent(e:Event){
			dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.HEADPOSITION, { time: _ns.time }));
		}
		
		/*
		public function sendLoadProgress(e:TimerEvent){
			if (_ns.bytesTotal != 0){
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.LOADPROGRESS, { loadprogress: _ns.bytesLoaded/_ns.bytesTotal }));
				if (_ns.bytesLoaded >= _ns.bytesTotal){
					_timer.stop();
				}
			}
		}
		*/
		
		public function mediaStopped(e:Event){
			removeEventListener(Event.ENTER_FRAME, sendHeadPositionEvent);
			_timer.stop();
		}
		
		// ------------------------------------
		
		public override function onMetaData(data:Object){
			trace("ScrubberVideoPlayer: "+_currentVideo+" duration: "+data.duration+" sec, orig size: "+_video.videoWidth+","+_video.videoHeight+", display size: "+_w+","+_h);
			_duration = data.duration;
			dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.DURATION, { duration: _duration }));
			addEventListener(Event.ENTER_FRAME, sendHeadPositionEvent);
			if (_timer != null){
				_timer.stop();
				_timer.start();
			} else {
				_timer = new Timer(50,0);
				_timer.addEventListener(TimerEvent.TIMER, sendLoadProgress);
				_timer.start();
			}
		}
	}
}