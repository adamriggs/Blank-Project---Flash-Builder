// SoundManager.as
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
//
//  License: Only Dave Cole and active Mekanism employees or contractors may use this code.
//
//	Manages multiple sounds and keeps them all in one tidy place.
//
//	Methods:
//		new SoundManager()						
//		addSound(linkageName, loopCount, autostart)		- Add a sound to soundmanager, specify linkage name or a URL ending in .mp3 (if loopcount is -1, it will loop infinitely)
//		removeSound(linkageName)				- Remove sound from soundmanager
//		playSound(linkageName)					- Play that sound
//		playSoundEvent(linkageName)			- Play sound only if it isn't already playing
//		stopSound(linkageName)					- Stop that sound
//		stopAllSounds()							- Stop all sounds
//
//		setVolume(linkageName, volume)			- Set the volume of the sound to desired value.  0-100
//		fadeIn(linkageName, fadeTime)			- Fade sound from 0 to 100 over fadeTime (in milliseconds)
//		fadeInAndStart(linkageName, fadeTime)	- Start sound and Fade sound from 0 to 100 over fadeTime
//		fadeTo(linkageName, fadeTime, volume)	- Fade sound from current volume to destination volume over fadeTime
//		fadeOut(linkageName, fadeTime)			- Fade sound from current volume to 0 over fadeTime (sound keeps playing at 0)
//		fadeOutAndStop(linkageName, fadeTime)	- Fade sound from current volume to 0 over fadeTime and then stop it.
//
//		setGlobalVolume(0-100)					- Set the global volume level
//		mute()									- mute the global volume
//		unmute()								- unmute the global volume
//


package com.dave.mediaplayers {
	import com.dave.mediaplayers.events.*;
	import com.dave.utils.DataTimer;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	public class SoundManager extends Object {
	
		public var _sounds:Object;
		private var _globalSound:SoundTransform;
		private var _highestVolume:Number;
		private const USE_GLOBAL_MUTE:Boolean = false;
		public var _mute:Boolean;
		
		public function SoundManager(){
			trace("new SoundManager()");
			init();
		}
		
		public function init():void{
			
			_globalSound = SoundMixer.soundTransform;
			_highestVolume = 1;
			_sounds = new Object();
			_mute = false;
		}
		
		
		public function setGlobalVolume(vol:Number):void{
			_highestVolume = vol;
			_globalSound.volume = vol;
			if (vol != 0){
				_mute = false;
			} else {
				_mute = true;
			}
		}
		
		
		public function mute():void{
			_mute = true;
			if (USE_GLOBAL_MUTE){
				_globalSound.volume = 0;
				SoundMixer.soundTransform = _globalSound;	
			} else {
				for (var snd:String in _sounds){
					setVolume(snd, 0);
				}
			}
		}
		public function unmute():void{
			_mute = false;
			if (USE_GLOBAL_MUTE){
				_globalSound.volume = _highestVolume;
				SoundMixer.soundTransform = _globalSound;
			} else {
				for (var snd:String in _sounds){
					setVolume(snd, 1);
				}
			}
		}
		
		public function stopAllSounds():void{
			SoundMixer.stopAll();
		}
	
		public function killAllSounds():void{
			for (var snd:String in _sounds){
				stopSound(snd);
			}
		}
		
		public function addSound(_linkageName:String, _loopCount:Number=0, autoStart:Boolean=false):void{
			trace("SoundManager.addSound("+_linkageName+", "+_loopCount+", "+autoStart+")");
			if (_sounds[_linkageName] == undefined || _sounds[_linkageName] == null){
				
				if (_linkageName.indexOf(".mp3",0) != -1){
					_sounds[_linkageName] = { loopCount:_loopCount, soundObject:new Sound(new URLRequest(_linkageName)), isPlaying: false, channel:null, position:0, transform:new SoundTransform(), fadeTimer:new Timer(100), origVolume:1, fadeInterval:0, fadeSlot:null, destVolume: 1 };
					if (_sounds[_linkageName].loopCount == -1){
						_sounds[_linkageName].loopCount = 999999; //999999; //Number.MAX_VALUE;
					}
					
					if (autoStart == true){
						_sounds[_linkageName].channel = _sounds[_linkageName].soundObject.play(0,_sounds[_linkageName].loopCount);
						_sounds[_linkageName].isPlaying = true;
					}
				} else {
					var myClass:Class = getDefinitionByName(_linkageName) as Class;
	
					_sounds[_linkageName] = { loopCount:_loopCount, soundObject:new myClass(), isPlaying: false, channel:null, position:0, transform:new SoundTransform(), fadeTimer:new Timer(100), origVolume:1, fadeInterval:0, fadeSlot:null, destVolume: 1 };
					if (_sounds[_linkageName].loopCount == -1){
						_sounds[_linkageName].loopCount = 999999; //Number.MAX_VALUE;
					}
					
					if (autoStart == true){
						_sounds[_linkageName].channel = _sounds[_linkageName].soundObject.play(0,_sounds[_linkageName].loopCount);
						_sounds[_linkageName].isPlaying = true;
					}
				}
				
				if (!USE_GLOBAL_MUTE){
					if (_mute){
						setVolume(_linkageName, 0);
					}
				}
			}
		}
		
		public function removeSound(_linkageName:String):void{
			if (_sounds[_linkageName] != undefined && _sounds[_linkageName] != null){
				stopSound(_linkageName);
				_sounds[_linkageName] == null;
			}
		}
		
		// returns true if sound is already added
		public function soundAdded(_linkageName:String):Boolean{
			return(_sounds[_linkageName] != undefined && _sounds[_linkageName] != null);
		}
		
		
		public function playSound(_linkageName:String, resetVolume:Boolean=false):void{
			trace("SoundManager.playSound("+_linkageName+") _mute=="+_mute+" USE_GLOBAL_MUTE=="+USE_GLOBAL_MUTE );
			if (_sounds[_linkageName] != undefined && _sounds[_linkageName] != null){
				if ((!USE_GLOBAL_MUTE && !_mute) || USE_GLOBAL_MUTE){
					if (_sounds[_linkageName].fadeTimer){
						_sounds[_linkageName].fadeTimer.stop();
					}
					_sounds[_linkageName].channel = _sounds[_linkageName].soundObject.play(0,_sounds[_linkageName].loopCount);
					if (resetVolume){
						_sounds[_linkageName].transform.volume = _sounds[_linkageName].origVolume = 1;
					}
					_sounds[_linkageName].channel.soundTransform = _sounds[_linkageName].transform;
					_sounds[_linkageName].isPlaying = true;
				}
			}
		}
		
		public function playSoundEvent(_linkageName:String, resetVolume:Boolean=false):void{
			trace("SoundManager.playSoundEvent("+_linkageName+")");
			if (_sounds[_linkageName] != undefined && _sounds[_linkageName] != null){
				if ((!USE_GLOBAL_MUTE && !_mute) || USE_GLOBAL_MUTE){
					if (_sounds[_linkageName].isPlaying == false){
						_sounds[_linkageName].channel = _sounds[_linkageName].soundObject.play(0,_sounds[_linkageName].loopCount);
						if (resetVolume){
							_sounds[_linkageName].transform.volume = _sounds[_linkageName].origVolume = 1;
						}
						_sounds[_linkageName].channel.soundTransform = _sounds[_linkageName].transform;
						_sounds[_linkageName].isPlaying = true;
					} else {
						if (_sounds[_linkageName].fadeTimer){
							_sounds[_linkageName].fadeTimer.stop();
						}
						if (resetVolume){
							_sounds[_linkageName].transform.volume = 1;
							_sounds[_linkageName].channel.soundTransform = _sounds[_linkageName].transform;
						} else {
							_sounds[_linkageName].transform.volume = _sounds[_linkageName].origVolume;
							_sounds[_linkageName].channel.soundTransform = _sounds[_linkageName].transform;
						}
					}
				}
			} 
		}
		
		public function stopSound(_linkageName:String):void{
			if (_sounds[_linkageName] != undefined && _sounds[_linkageName] != null){
				if (_sounds[_linkageName].isPlaying){
					if (_linkageName.indexOf(".mp3",0) != -1){
						try {
							_sounds[_linkageName].soundObject.close();
						} catch (e:Error){
							trace("SoundManager.stopSound - '"+_linkageName+"' doesn't have a stream open");
						} finally {
							_sounds[_linkageName].channel.stop();
						}
					} else {
						_sounds[_linkageName].channel.stop();
					}
					_sounds[_linkageName].isPlaying = false;
				}
			}
		}
		
		public function pauseSound(_linkageName:String):void{
			if (_sounds[_linkageName] != undefined && _sounds[_linkageName] != null){
				if (_sounds[_linkageName].isPlaying){
					_sounds[_linkageName].position = _sounds[_linkageName].channel.position;
					_sounds[_linkageName].channel.stop();
					_sounds[_linkageName].isPlaying = false;
				}
			}
		}
		
		public function unpauseSound(_linkageName:String):void{
			if (_sounds[_linkageName] != undefined && _sounds[_linkageName] != null){
				if (!_sounds[_linkageName].isPlaying){
					_sounds[_linkageName].channel = _sounds[_linkageName].soundObject.play(_sounds[_linkageName].position, _sounds[_linkageName].loopCount);
					_sounds[_linkageName].isPlaying = true;
				}
			}
		}
	

		public function setVolume(_linkageName:String, num:Number):void{ // 0-1
			trace("SoundManager.setVolume("+_linkageName+", "+num+")");
			if (_sounds[_linkageName] != undefined && _sounds[_linkageName] != null){
				
				if (_sounds[_linkageName].fadeTimer){
					_sounds[_linkageName].fadeTimer.stop();
				}
				
				_sounds[_linkageName].transform.volume = _sounds[_linkageName].origVolume = num;
				
				if (_sounds[_linkageName].channel){
					_sounds[_linkageName].channel.soundTransform = _sounds[_linkageName].transform;
				}
			}
		}
		
		
		public function fadeTo(_linkageName:String, num:Number, milliseconds:Number):void{
			if (_sounds[_linkageName] != undefined && _sounds[_linkageName] != null){
				if ((!USE_GLOBAL_MUTE && !_mute) || USE_GLOBAL_MUTE){
					trace("SoundManager.fadeTo("+_linkageName+", "+num+", "+milliseconds);
					if (_sounds[_linkageName].fadeTimer){
						_sounds[_linkageName].fadeTimer.stop();
					}
					_sounds[_linkageName].fadeTimer = new DataTimer(milliseconds/100,100);
					_sounds[_linkageName].fadeTimer.data.target = _sounds[_linkageName];
					_sounds[_linkageName].fadeTimer.addEventListener(TimerEvent.TIMER, fader);
					_sounds[_linkageName].origVolume = _sounds[_linkageName].transform.volume;
					_sounds[_linkageName].destVolume = num;
					_sounds[_linkageName].fadeInterval = (num - _sounds[_linkageName].origVolume)/100;
					_sounds[_linkageName].fadeTimer.start();
				}
			}
		}
		
		public function fadeInAndStart(_linkageName:String, milliseconds:Number):void{
			fadeIn(_linkageName, milliseconds);
		}
		
		public function fadeIn(_linkageName:String, milliseconds:Number):void{
			if (_sounds[_linkageName] != undefined && _sounds[_linkageName] != null){
				if ((!USE_GLOBAL_MUTE && !_mute) || USE_GLOBAL_MUTE){
					if (_sounds[_linkageName].isPlaying == false){
						_sounds[_linkageName].channel = _sounds[_linkageName].soundObject.play(0,_sounds[_linkageName].loopCount);
						_sounds[_linkageName].transform.volume = _sounds[_linkageName].origVolume = 0;
						_sounds[_linkageName].channel.soundTransform = _sounds[_linkageName].transform;
						_sounds[_linkageName].isPlaying = true;
						fadeTo(_linkageName, 1, milliseconds);
					} else {
						if (_sounds[_linkageName].fadeTimer){
							_sounds[_linkageName].fadeTimer.stop();
						}
						fadeTo(_linkageName, 1, milliseconds);
					}
				}
			} 
		}
	
		public function fadeOut(_linkageName:String, milliseconds:Number):void{
			if ((!USE_GLOBAL_MUTE && !_mute) || USE_GLOBAL_MUTE){
				fadeTo(_linkageName, 0, milliseconds);
			}
		}
		
		public function fadeOutAndStop(_linkageName:String, milliseconds:Number):void{
			if (_sounds[_linkageName] != undefined && _sounds[_linkageName] != null){
				if ((!USE_GLOBAL_MUTE && !_mute) || USE_GLOBAL_MUTE){
					fadeTo(_linkageName,0,milliseconds);
					if (_linkageName.indexOf(".mp3",0) != -1){
						_sounds[_linkageName].fadeTimer.data.onComplete = function(target:Object):void{ try { target.soundObject.close(); } catch (e:Error){} target.isPlaying = false; };
					} else {
						_sounds[_linkageName].fadeTimer.data.onComplete = function(target:Object):void{ target.channel.stop(); target.isPlaying = false; };
					}
				}
			}
		}
		
		private function fader(e:TimerEvent):void{
			if ((!USE_GLOBAL_MUTE && !_mute) || USE_GLOBAL_MUTE){
				try {
					var tmr:DataTimer = e.currentTarget as DataTimer;
					tmr.data.target.transform.volume = Math.min(1,Math.max(0,tmr.data.target.origVolume += tmr.data.target.fadeInterval));
					tmr.data.target.channel.soundTransform = tmr.data.target.transform;
					if (tmr.data.target.transform.volume == tmr.data.target.destVolume){
						
						tmr.data.target.fadeTimer.stop();
						if (tmr.data.onComplete != null){
							
							tmr.data.onComplete(tmr.data.target);
						}
					}
				} catch(e:Error){ 
					try {
						tmr.data.target.fadeTimer.stop();
						tmr.data.onComplete(tmr.data.target);
					} catch (e:Error){}
				}
			} else {
				try {
					tmr.data.target.fadeTimer.stop();
					tmr.data.onComplete(tmr.data.target);
				} catch (e:Error){}
			}
		}
		
	
	}
}
