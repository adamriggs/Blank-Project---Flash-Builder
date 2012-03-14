// ScrubberAudioPlayer.as
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
//
//
//  License: Only Dave Cole and active Mekanism employees or contractors may use this code.
//
// 
package com.dave.mediaplayers {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.utils.Timer;
	import com.dave.utils.DaveTimer;
	import flash.utils.getDefinitionByName;
	
	import com.dave.mediaplayers.Scrubber;
	import com.dave.mediaplayers.events.*;
	
	public class ScrubberAudioPlayer extends MovieClip {
		public var _scrubberReference:MovieClip;
		public var _x,_y,_w:int;
		public var _bufferTime:Number;
		
		private var _lastPosition:Number;
		public var _stopped:Boolean;
		public var _file:String;
		public var _sound:Sound;
		public var _paused:Boolean;
		public var _channel:SoundChannel;
		public var _transform:SoundTransform;
		public var _autoStart:Boolean;
		public var _timer,_fadeTimer:Timer;
		
		private var fadeInterval:Number;
		
		public var _volume, _destVolume, _origVolume:Number;
		public var _mute:Boolean;
		
		public var _duration:Number;
		
		public function ScrubberAudioPlayer(xPos:int, yPos:int, w:int, autoStart:Boolean, soundFile:String, bufferTimeDuration:Number, scrubberReference:Scrubber=null){
			trace("new ScrubberAudioPlayer("+xPos+", "+yPos+", "+w+", "+bufferTimeDuration+", "+scrubberReference);
			_x = xPos;
			_y = yPos;
			_w = w;
			_bufferTime = bufferTimeDuration;
			_scrubberReference = scrubberReference;
			_file = soundFile;
			_lastPosition = 0;
			_stopped = true;
			_paused = false;
			_channel = new SoundChannel();
			_transform = new SoundTransform();
			_autoStart = autoStart;
			_mute = false;
			_fadeTimer = new Timer(100);
			_volume = 1;
			
			if (_scrubberReference != null){
				initScrubber();
			}
			init();
			
		}
		
		public function init(){
			if (_file != ""){
				loadFile(_file);
				if (_autoStart){
					playAudio();
				} else {
					dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.PAUSED, { file: _file }));
				}
			}
		}
		
		public function initScrubber(){
			_scrubberReference.x = _x;
			_scrubberReference.y = _y;
			addChild(_scrubberReference);
		
			_scrubberReference.addEventListener(MediaControlEvent.PLAY, playButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.PAUSE, pauseButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.REWIND, rewindButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.STOP, stopButtonPressed);
			_scrubberReference.addEventListener(MediaControlEvent.SEEK_MOUSEUP, scrubberSeekMouseUp);
			_scrubberReference.addEventListener(MediaControlEvent.SEEK,scrubberSeek);
			_scrubberReference.addEventListener(MediaControlEvent.VOLUME, volumeSet);
			
			this.addEventListener(MediaPlaybackEvent.PLAYING, _scrubberReference.mediaPlaying);
			this.addEventListener(MediaPlaybackEvent.PAUSED, _scrubberReference.mediaPaused);
			this.addEventListener(MediaPlaybackEvent.STOPPED, _scrubberReference.mediaStopped);
			this.addEventListener(MediaPlaybackEvent.DURATION, _scrubberReference.durationReceived);
			this.addEventListener(MediaPlaybackEvent.HEADPOSITION, _scrubberReference.mediaSeekUpdate);
			this.addEventListener(MediaPlaybackEvent.STOPPED, mediaStopped);
			this.addEventListener(MediaPlaybackEvent.LOADPROGRESS, _scrubberReference.loadProgress);
		}
		
		
		
		public function playAudio(loops:int=0){
			if (_stopped){
				loadFile(_file);
			}
			_channel = _sound.play(0,loops);
			_paused = false;
			dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.PLAYING, { file: _file }));
			startedPlaying();
		}
		
		public function playAudioSeek(num:Number){
			if (_stopped){
				loadFile(_file);
			}
			_channel = _sound.play(num);
			_paused = false;
			dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.PLAYING, { file: _file }));
			startedPlaying();
		}
		
		public function loadFile(file:String){
			_file = file;
			
			if (file.indexOf(".mp3") != -1){
				_sound = new Sound(new URLRequest(_file));
				_stopped = false;
				_paused = true;
				if (_timer != null){
					_timer.stop();
					_timer.start();
				} else {
					_timer = new Timer(50,0);
					_timer.addEventListener(TimerEvent.TIMER, sendLoadProgress);
					_timer.start();
				}
			} else {
				var myClass:Object = getDefinitionByName(file);
				
				_sound = myClass();
				_stopped = false;
				_paused = true;
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.LOADPROGRESS, { loadprogress: 1 }));
				
			}
		}
		
		public function pauseAudio(){
			if (_stopped){
				
			} else if (!_paused){
				_lastPosition = _channel.position;
				_channel.stop();
				_paused = true;
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.PAUSED, { file: _file }));
				stoppedPlaying();
			}
		}
		
		public function unpauseAudio(){
			if (_stopped){
				loadFile(_file);
				playAudio();
			} else if (_paused){
				_channel = _sound.play(_lastPosition);
				_paused = false;
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.PLAYING, { file: _file }));
				startedPlaying();
			}
		}
		
		public function SeekunpauseAudio(num:Number){
			if (_stopped){
				loadFile(_file);
				playAudioSeek(num);
			} else if (_paused){
				_channel = _sound.play(num);
				_paused = false;
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.PLAYING, { file: _file }));
				startedPlaying();
			}
		}
		
		public function stopAudio(){
			trace("ScrubberAudioPlayer.stopAudio() _stopped == "+_stopped);
			if (!_stopped){
				_lastPosition = 0;
				_paused = false;
				try {
					_sound.close();
					_stopped = true;
				} catch (e:Error){
					trace("ScrubberAudioPlayer.stopAudio - Error: This URLStream object does not have a stream opened.");
					pauseAudio();
				}
				
				
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.STOPPED, { file: _file }));
				stoppedPlaying();
			
			}
		}
		
		public function seekTo(num:Number){
			//_channel.stop();
			
			//_sound.play(num);
			SeekunpauseAudio(num);
			_paused = false;
			//startedPlaying();
		}
		
		public function rewindAudio(){
			_channel.stop();
			playAudio();
			_stopped = false;
			startedPlaying();
		}
		
		public function setVolume(num:Number, muted:Boolean=false){ // 0-1
			trace("ScrubberAudioPlayer.setVolume("+num+", "+muted+")");
			_fadeTimer.stop();
			_transform.volume = num;
			_channel.soundTransform = _transform;
			if (!muted){
				_volume = num;
			}
		}
		
		public function fadeTo(num:Number, milliseconds:Number, unmute:Boolean=false){
			_fadeTimer.stop();
			if (_mute){
				if (unmute){
					_mute = false;
					setVolume(0);
				
					_fadeTimer = new Timer(milliseconds/100,100);
					_fadeTimer.addEventListener(TimerEvent.TIMER, fader);
					_destVolume = num;
					_origVolume = _volume;
					fadeInterval = (num - _volume)/10;
					_fadeTimer.start();
				}
			} else {
				
				_fadeTimer = new Timer(milliseconds/100,100);
				_fadeTimer.addEventListener(TimerEvent.TIMER, fader);
				_destVolume = num;
				_origVolume = _volume;
				fadeInterval = (num - _volume)/10;
				_fadeTimer.start();
			}
		}
		public function fader(e:TimerEvent){
			_transform.volume = Math.min(1,Math.max(0,_origVolume += fadeInterval));
			_channel.soundTransform = _transform;
			_volume = _transform.volume;
		}
		
		public function mute(bool:Boolean){
			if (bool){
				_mute = true;
				_origVolume = _volume;
				setVolume(0,true);
			} else {
				_mute = false;
				setVolume(_volume);
			}
		}
		
		// ---- Event Handlers --------------
		
		public function volumeSet(e:MediaControlEvent){
			setVolume(e.args.volumenum);
		}
		
		public function playButtonPressed(e:Event){
			unpauseAudio();
			setVolume(_volume);
		}
		
		public function pauseButtonPressed(e:Event){
			pauseAudio();
		}
		
		public function rewindButtonPressed(e:Event){
			rewindAudio();
		}
		
		public function stopButtonPressed(e:Event){
			stopAudio();
			_timer.stop();
		}
		
		public function scrubberSeek(e:MediaControlEvent){
			pauseAudio();
			sendFakeHeadPosition();
		}
		
		public function scrubberSeekMouseUp(e:MediaControlEvent){
			seekTo(e.args.time);
			setVolume(_volume);
		}
			
		public function sendHeadPositionEvent(e:Event){
			if (_sound.bytesLoaded >= _sound.bytesTotal){
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.HEADPOSITION, { time: _channel.position, duration: _sound.length }));
				_scrubberReference.scrubber_nub.visible = true;
			} else {
				_scrubberReference.scrubber_nub.visible = false;
			}
		}
		
		public function sendFakeHeadPosition(){
			//if (_sound.bytesLoaded >= _sound.bytesTotal){
				var pos:Number = (_scrubberReference.mouseX - _scrubberReference.scrubber_well.x)/_scrubberReference.scrubber_well.width;
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.HEADPOSITION, { time: pos * _sound.length }));
			//}
		}
		
		public function mediaStopped(e:Event){
			if (_scrubberReference != null){
				removeEventListener(Event.ENTER_FRAME, sendHeadPositionEvent);
			}
		}
		
		public function sendLoadProgress(e:TimerEvent){
			if (_sound.bytesTotal != 0){
				dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.LOADPROGRESS, { loadprogress: _sound.bytesLoaded/_sound.bytesTotal }));
				if (_sound.bytesLoaded >= _sound.bytesTotal){
					_timer.stop();
				}
			}
		}
		
		// ------------------------------------
		
		public function startedPlaying(){
			trace("startedPlaying() - "+_sound.length);
			_duration = _sound.length;
			if (_scrubberReference != null){
				addEventListener(Event.ENTER_FRAME, sendHeadPositionEvent);
			}
			DaveTimer.wait(300,futz);
			
		}
		
		public function futz(e:TimerEvent){
			dispatchEvent(new MediaPlaybackEvent(MediaPlaybackEvent.DURATION, { duration: _sound.length }));
			_duration = _sound.length;
		}
		
		public function stoppedPlaying(){
			removeEventListener(Event.ENTER_FRAME, sendHeadPositionEvent);
		}
		
		public function onTimer(e:TimerEvent){
			startedPlaying();
		}
	}
}