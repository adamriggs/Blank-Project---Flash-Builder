// SimpleVideoPlayer
// AS3 v1.1
// Copyright 2007 Dave Cole - All Rights Reserved
//
//
//  License: Only Dave Cole and active Mekanism employees or contractors may use this code.
//

package com.dave.mediaplayers {
	
	import com.dave.mediaplayers.events.*;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	

	public class SimpleVideoPlayer extends Sprite {
		
		public var _nc:NetConnection;
		public var _ns:NetStream;
		public var _video:Video;
		public var _soundTransform:SoundTransform;
		public var _parentObject:Object;
		public var _origSize:Boolean;
		
		public var _currentVideo:String;
		public var _videoList:Array;
		public var _videoIndex:int;
		
		public var _w:int;
		public var _h:int;
		public var _x:int;
		public var _y:int;
		public var _bufferTime:Number;
		public var _autoStart:Boolean;
		public var _stopped:Boolean;
		public var _paused:Boolean;
		public var _duration:Number;
				
		private var _client:Object;
		private var _timer:Timer;
		
		public var _loop:Boolean;
		private var _smoothing:Boolean;
		
		public var _bufferInterval:Timer;
		public var _bufferIndicator:TextField;
		
		public function SimpleVideoPlayer(xPos:int, yPos:int, w:int, h:int, autoStart:Boolean, bufferTimeDuration:Number, globalNetConnection:NetConnection, parentObject:Object, origSize:Boolean=false, smoothing:Boolean=false):void{
			trace("new SimpleVideoPlayer("+xPos+", "+yPos+", "+w+", "+h+", "+autoStart+", "+bufferTimeDuration+", "+globalNetConnection+", "+parentObject);
			_x = xPos;
			_y = yPos;
			_w = w;
			_h = h;
			_autoStart = autoStart;
			_bufferTime = bufferTimeDuration;
			_nc = globalNetConnection;
			_parentObject = parentObject;
			_origSize = origSize;
			_smoothing = smoothing;
			
			_loop = false;
			
			_stopped = true;
			_paused = false;
			_duration = 0;
			
			_currentVideo = "";
			_videoList = new Array();
			
			init();
		}
		
		public function init():void{
			if (_nc == null){
				_nc = new NetConnection();
				_nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
        	    _nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_nc.connect(null);
			}
			
			_ns = new NetStream(_nc);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            _ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			_client = new Object();
			_client.onMetaData = onMetaData;
			_client.onCuePoint = onCuePoint;
			_ns.client = _client;
			
			_soundTransform = _ns.soundTransform;
			
			_video = new Video(_w, _h);
			_video.x = _x;
			_video.y = _y;
			_video.width = _w;
			_video.height = _h;
			addChild(_video);
			_video.attachNetStream(_ns);
			
			if (_smoothing){
				_video.smoothing = true;
			}
			
			
			createBufferIndicator();
		}
		
		private function createBufferIndicator():void{
			_bufferIndicator = new TextField();
			_bufferIndicator.text = "BUFFERING...";
			_bufferIndicator.autoSize = TextFieldAutoSize.CENTER;
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Arial";
			textFormat.bold = true;
			textFormat.size = 10;
			textFormat.color = 0xFFFFFF;
			_bufferIndicator.x = Math.floor(_w / 2) + _x;
			_bufferIndicator.y = Math.floor(_h / 2) + _y;
			_bufferIndicator.setTextFormat(textFormat);
		}


		
		public function kill():void{
			stopVideo();
			_ns = null;
			_nc = null;
			_stopped = true;
			_paused = false;
			stopRebuffering();
			hideBufferIndicator();
			_bufferIndicator = null;
			removeChild(_video);
			_video = null;
			this._parentObject.removeChild(this);
		}
		
		
		// ---- Playback routines ---------------------
		
		public function playVideo( ...videos ):void{
			trace("SimpleVideoPlayer.playVideo("+videos+")");
			if (videos.length > 0){
				_videoList = videos;
				_videoIndex = -1;
				playNextVideo();
			}
		}
		
		public function playNextVideo():void{
			
			if (++_videoIndex < _videoList.length){
				//trace("SimpleVideoPlayer.playNextVideo() - now it's: "+_videoIndex+" "+_videoList[_videoIndex]);
				_currentVideo = _videoList[_videoIndex];
				playVid(_currentVideo);
			} else {
				_paused = false;
				_stopped = true;
				//trace("SimpleVideoPlayer: videoDone(null)");
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.DONEPLAYING, { file: _currentVideo } ));
				
			}
		}
		
		private function playVid(vid:String):void{
			//_video.clear();  // makes a blink happen
			_currentVideo = vid;
			_duration = 0;
			_ns.bufferTime = _bufferTime;
			trace("SimpleVideoPlayer: Loading file: "+_currentVideo);
			_paused = false;
			_stopped = false;
			if (_videoIndex >= _videoList.length){
				_videoIndex = 0;
			}
			if (!_autoStart){
				setVolume(0);
			}
			_ns.play(_videoList[_videoIndex]);
			//Application.shell.showLoader(true);  // *** custom
		}
		
		public function repeatVideo():void{
			rewindVideo();
			_ns.play(_videoList[_videoIndex]);
		}
		
		public function pauseVideo():void{
			//trace("SimpleVideoPlayer.pauseVideo() - "+_currentVideo);
			if (_paused == false && !_stopped){
				_paused = true;
				_ns.pause();
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.PAUSED, { file: _currentVideo } ));
			} 
		}
		
		public function pauseAndRewindVideo():void{
			
			rewindVideo();
			pauseVideo();
		}
		public function rewindAndPauseVideo():void{
			
			rewindVideo();
			pauseVideo();
		}
		
		public function unpauseVideo():void{
			//trace("SimpleVideoPlayer.unpauseVideo() - "+_currentVideo);
			if (_paused == true && !_stopped){
				_paused = false;
				_stopped = false;
				_ns.resume();
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.PLAYING, { file: _currentVideo } ));
			} else if (_stopped){
				if (_currentVideo != ""){
					playVid(_currentVideo);
					_paused = false;
					_stopped = false;
				}
			}
		}
		
		public function rewindVideo():void{
			seekTo(0);
		}
		
		public function stopVideo():void{
			//trace("SimpleVideoPlayer.stopVideo() - "+_currentVideo);
			_ns.close();
			_stopped = true;
			_paused = false;
		}
		
		public function seekTo(num:Number):void{
			if (num < _duration && num >= 0){
				_ns.seek(num);
				unpauseVideo();
			}
		}
		
		public function clearDisplay():void{
			_video.clear();
		}
		
		public function setVolume(vol:Number):void{
			_soundTransform.volume = vol;  // 0-1
			_ns.soundTransform = _soundTransform;
		}
		
		public function getVolume():Number{
			return(_soundTransform.volume);
		}
		
		public function getTime():Number{
			return(_ns.time);
		}
		
		// ---- Interface routines --------------------
		
		private function showBufferIndicator():void{
			//addChild(_bufferIndicator);
			//Application.shell.showLoader(true);
		}
		
		private function hideBufferIndicator():void{
			//removeChild(_bufferIndicator);
			//Application.shell.showLoader(false);  // *** custom
		}
		
		private function startRebuffering():void{
			// create a timer if we need it
		}
		
		private function stopRebuffering():void{
			// stop the timer if we need it
		}
		
		public function setSmoothing(bool:Boolean):void{
			_video.smoothing = bool;
		}
		
		
		// ---- Net Status routines -------------------
		
		
		public function sendLoadProgress(e:TimerEvent):void{
			try {
				if (_ns.bytesTotal != 0){
					dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.LOADPROGRESS, { loadprogress: _ns.bytesLoaded/_ns.bytesTotal }));
					if (_ns.bytesLoaded >= _ns.bytesTotal){
						if (_timer != null){
							_timer.stop();
						}
					}
				}
			} catch (e:Error){
				try {
					_timer.stop();
				} catch (e:Error){
					
				}
			}
		}
		
		
		public function onMetaData(data:Object):void{
			//trace("SimpleVideoPlayer: "+_currentVideo+" duration: "+data.duration+" sec, orig size: "+_video.videoWidth+","+_video.videoHeight+", display size: "+_w+","+_h);
			_duration = data.duration;
			if (_origSize && _video.videoWidth != 0 && _video.videoHeight != 0){
				_video.width = _video.videoWidth;
				_video.height = _video.videoHeight;
			}
			dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.DURATION, { duration: _duration }));
			if (_timer != null){
				_timer.stop();
				_timer.start();
			} else {
				_timer = new Timer(50,0);
				_timer.addEventListener(TimerEvent.TIMER, sendLoadProgress);
				_timer.start();
			}
		}
		
		public function onCuePoint(cuePoint:Object):void{
			trace("[] SimpleVideoPlayer: "+_currentVideo+" CUE POINT at "+cuePoint.time+" sec: "+cuePoint.name);
			dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.CUEPOINT, { cuePoint: cuePoint }));
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			//trace("SimpleVideoPlayer: NetStatusEvent: "+event.info.code);
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    
                    break;
					
 				case "NetStream.Play.StreamNotFound":
                   // trace("SimpleVideoPlayer: Unable to locate video: " + _currentVideo);
                    break;

				case "NetStream.Play.Start":
					if (!_autoStart){
						pauseVideo();
						_autoStart = true;
						setVolume(1);
					} else {
						_stopped = false;
						_paused = false;
				
						dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.PLAYING, { file: _currentVideo } ));
					}
					break;
					
				case "NetStream.Buffer.Full":
					hideBufferIndicator();
					stopRebuffering();
					_ns.bufferTime = _bufferTime * 5;
					break;
				
				case "NetStream.Buffer.Empty":
					showBufferIndicator();
					_ns.bufferTime = _bufferTime;
					startRebuffering();
					break;
					
				case "NetStream.Play.Stop":
					stopRebuffering();
					_stopped = true;
					
					dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.STOPPED, { file: _currentVideo } ));
					
					if (!_loop){
						this.playNextVideo();
					} else {
						this.repeatVideo();
					}
					
					break;
					
				case "":
					
					break;
					
				case "":
					
					break;
 			}
        }
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("SimpleVideoPlayer: securityErrorHandler: " + event);
        }
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void {
            // ignore AsyncErrorEvent events.
        }

	}
}