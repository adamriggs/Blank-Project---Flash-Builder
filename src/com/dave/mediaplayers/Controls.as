// Controls.as
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
//
//
//  License: Only Dave Cole and active Mekanism employees or contractors may use this code.
//
//	This class defines a scrubber's functionality and manages its assets.
//
package com.dave.mediaplayers {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import com.dave.mediaplayers.events.*;
	
	public class Controls extends MovieClip {
		public var _x,_y:int;
		public var _showPlayPauseButton,_showStopButton,_showRewindButton, _showMuteButton:Boolean;
	
		public var play_btn, pause_btn, stop_btn, rewind_btn, volume_speaker:MovieClip;
		
		private var _duration;
		
		private var i:int;
		
		public function Controls(xPos:int, yPos:int, showPlayPauseButton:Boolean, showStopButton:Boolean, showRewindButton:Boolean, showMuteButton:Boolean){
			trace("new Controls("+xPos+", "+yPos+", "+showPlayPauseButton+", "+showStopButton+", "+showRewindButton+")");
			_x = xPos;
			_y = yPos;
			
			_showPlayPauseButton = showPlayPauseButton;
			_showStopButton = showStopButton;
			_showRewindButton = showRewindButton;
			_showMuteButton = showMuteButton;
			
			_duration = 0;
			
			play_btn.useHandCursor = play_btn.buttonMode = true;
			pause_btn.useHandCursor = pause_btn.buttonMode = true;
			
			stop_btn.useHandCursor = stop_btn.buttonMode = true;
			rewind_btn.useHandCursor = rewind_btn.buttonMode = true;
			
			volume_speaker.useHandCursor = volume_speaker.buttonMode = true;
			init();
			
		}
		
		public function init(){
			resizeDisplay();
			
		}
		
		public function resizeDisplay(){
			this.x = _x;
			this.y = _y;
			
			if (_showPlayPauseButton){
				play_btn.visible = true;
				pause_btn.visible = false;
				
				play_btn.addEventListener(MouseEvent.CLICK, play_btn_mouseDown);
				pause_btn.addEventListener(MouseEvent.CLICK, pause_btn_mouseDown);
			} else {
				play_btn.visible = false;
				pause_btn.visible = false;
			}
			
			if (_showStopButton){
				stop_btn.visible = true;
				stop_btn.addEventListener(MouseEvent.CLICK, stop_btn_mouseDown);
			} else {
				stop_btn.visible = false;
			}
			
			if (_showRewindButton){
				rewind_btn.visible = true;
				rewind_btn.addEventListener(MouseEvent.CLICK, rewind_btn_mouseDown);
			} else {
				rewind_btn.visible = false;
			}
			
			if (_showMuteButton){
				volume_speaker.visible = true;
				volume_speaker.addEventListener(MouseEvent.CLICK, mute_btn_mouseDown);
			} else {
				volume_speaker.visible = false;
			}
		}
		

		
		public function play_btn_mouseDown(e:Event){
			trace("play_btn_mouseDown "+e.target);
			dispatchEvent(new MediaControlEvent(MediaControlEvent.PLAY,null));
		}
		public function pause_btn_mouseDown(e:Event){
			trace("pause_btn_mouseDown "+e.target);
			dispatchEvent(new MediaControlEvent(MediaControlEvent.PAUSE,null));
		}
		public function stop_btn_mouseDown(e:Event){
			dispatchEvent(new MediaControlEvent(MediaControlEvent.STOP,null));
			
		}
		public function rewind_btn_mouseDown(e:Event){
			dispatchEvent(new MediaControlEvent(MediaControlEvent.REWIND,null));
		}
		
		public function mute_btn_mouseDown(e:MouseEvent){
			if (volume_speaker.speaker_on.visible){
				volume_speaker.speaker_on.visible = false;
				volume_speaker.speaker_off.visible = true;
				dispatchEvent(new MediaControlEvent(MediaControlEvent.MUTE, { mute: true }));
			} else {
				volume_speaker.speaker_on.visible = true;
				volume_speaker.speaker_off.visible = false;
				dispatchEvent(new MediaControlEvent(MediaControlEvent.MUTE, { mute: false }));
			}
		}
		
		
		
		// ---- Event Handlers ------------------
		
		public function mediaPlaying(e:MediaPlaybackEvent){
			pause_btn.visible = true;
			play_btn.visible = false;
		}
		public function mediaPaused(e:MediaPlaybackEvent){
			
			play_btn.visible = true;
			pause_btn.visible = false;
		}
		public function mediaStopped(e:MediaPlaybackEvent){
			
			play_btn.visible = true;
			pause_btn.visible = false;
			_duration = 0;
			
		}
		public function durationReceived(e:MediaPlaybackEvent){
			_duration = e.args.duration;
			
		}
		
		
	}
}