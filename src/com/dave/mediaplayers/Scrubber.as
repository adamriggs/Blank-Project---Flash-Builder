// Scrubber.as
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
	
	public class Scrubber extends MovieClip {
		public var _x,_y,_w,_leftIndent,_rightIndent,_wellIndent,_volume_well_x,_volume_well_width:int;
		public var _showPlayPauseButton,_showStopButton,_showRewindButton,_useNubInsteadOfBar:Boolean;
	
		public var bkg, play_btn, pause_btn, stop_btn, rewind_btn, scrubber_well, scrubber_hotspot, scrubber_nub, scrubber_loadingbar:MovieClip;
		
		private var _duration, _hotspotOrigWidth;
		
		private var i:int;
		
		public function Scrubber(xPos:int, yPos:int, totalWidth:int, leftIndent:int, rightIndent:int, wellIndent:int, showPlayPauseButton:Boolean, showStopButton:Boolean, showRewindButton:Boolean, useNubInsteadOfBar:Boolean, volume_well_x:int=0, volume_well_width:int=0){
			trace("new Scrubber("+xPos+", "+yPos+", "+totalWidth+", "+leftIndent+", "+rightIndent+", "+wellIndent+", "+showPlayPauseButton+", "+showStopButton+", "+showRewindButton+", "+useNubInsteadOfBar+", "+volume_well_x+", "+volume_well_width+")");
			_x = xPos;
			_y = yPos;
			_w = totalWidth;
			_showPlayPauseButton = showPlayPauseButton;
			_showStopButton = showStopButton;
			_showRewindButton = showRewindButton;
			trace("fff");
			_leftIndent = leftIndent;
			_rightIndent = rightIndent;
			_wellIndent = wellIndent;
			_useNubInsteadOfBar = useNubInsteadOfBar;
			_volume_well_x = volume_well_x;
			_volume_well_width = volume_well_width;
			trace("asdf");
			_duration = 0;
			//trace("wwidth =="+scrubber_hotspot.width);
			_hotspotOrigWidth = scrubber_hotspot.width;
			trace("fdsa");
			play_btn.useHandCursor = play_btn.buttonMode = true;
			pause_btn.useHandCursor = pause_btn.buttonMode = true;
			trace("ffffffff");
			stop_btn.useHandCursor = stop_btn.buttonMode = true;
			rewind_btn.useHandCursor = rewind_btn.buttonMode = true;
			scrubber_nub.useHandCursor = scrubber_nub.buttonMode = true;
		
			trace("hi");
			init();
			
		}
		
		public function init(){
			resizeDisplay();
			
		}
		
		public function resizeDisplay(){
			this.x = _x;
			this.y = _y;
			
			bkg.x = 0;
			bkg.width = _w;
			
			var resultwidth:int = _leftIndent + _rightIndent;
			
			if (_showPlayPauseButton){
				play_btn.visible = true;
				pause_btn.visible = false;
				play_btn.x = _leftIndent;
				pause_btn.x = _leftIndent;
				resultwidth += play_btn.width;
				
				play_btn.addEventListener(MouseEvent.CLICK, play_btn_mouseDown);
				pause_btn.addEventListener(MouseEvent.CLICK, pause_btn_mouseDown);
			} else {
				play_btn.visible = false;
				pause_btn.visible = false;
			}
			
			if (_showStopButton){
				stop_btn.visible = true;
				stop_btn.x = play_btn.x + play_btn.width;
				resultwidth += stop_btn.width;
				
				stop_btn.addEventListener(MouseEvent.CLICK, stop_btn_mouseDown);
			} else {
				stop_btn.visible = false;
				stop_btn.x = play_btn.x;
			}
			
			if (_showRewindButton){
				rewind_btn.visible = true;
				rewind_btn.x = stop_btn.x + stop_btn.width;
				resultwidth += rewind_btn.width;
				
				rewind_btn.addEventListener(MouseEvent.CLICK, rewind_btn_mouseDown);
			} else {
				rewind_btn.visible = false;
				rewind_btn.x = stop_btn.x;
			}
			
			//if (_volume_well_width != 0){
				//scrubber_well.width = scrubber_hotspot.width = _w - (resultwidth + _wellIndent + (_volume_well_width + 10));
			//} else {
			scrubber_well.width = scrubber_hotspot.width = _w - (resultwidth + _wellIndent);
			//}
			scrubber_well.x = scrubber_hotspot.x = scrubber_loadingbar.x = rewind_btn.x + rewind_btn.width + _wellIndent;
			scrubber_loadingbar.width = 0;
			
			scrubber_hotspot.addEventListener(MouseEvent.MOUSE_DOWN, scrubber_hotspot_mouseDown);
			scrubber_hotspot.addEventListener(MouseEvent.MOUSE_UP, scrubber_hotspot_mouseUp);
			//scrubber_hotspot.addEventListener(MouseEvent.CLICK, scrubber_hotspot_click);
			
			
			if (_useNubInsteadOfBar){
				scrubber_nub.x = scrubber_well.x;
				
			} else {
				scrubber_nub.width = 0;
				scrubber_nub.x = scrubber_well.x;
				
			}
			scrubber_nub.visible = false;
		}
		

		public function scrubber_hotspot_mouseDown(e:MouseEvent){
			var offset:Number = 0;
			if (_useNubInsteadOfBar){
				offset = scrubber_nub.width / 2;
			}
			
			dispatchEvent(new MediaControlEvent(MediaControlEvent.SEEK, { time: Math.round(((((e.localX - offset) / _hotspotOrigWidth) * scrubber_well.width) / scrubber_well.width) * _duration) }));
			//trace("seeking: "+((((e.localX - offset) / _hotspotOrigWidth) * scrubber_well.width) / scrubber_well.width));
			
			scrubber_hotspot.addEventListener(MouseEvent.MOUSE_MOVE, scrub);
		}
		//public function scrubber_hotspot_click(e:Event){
			
		//}
		public function scrubber_hotspot_mouseUp(e:MouseEvent){
			scrubber_hotspot.removeEventListener(MouseEvent.MOUSE_MOVE, scrub);
			
			var offset:Number = 0;
			if (_useNubInsteadOfBar){
				offset = scrubber_nub.width / 2;
			}
			dispatchEvent(new MediaControlEvent(MediaControlEvent.SEEK_MOUSEUP, { time: Math.round(((((e.localX - offset) / _hotspotOrigWidth) * scrubber_well.width) / scrubber_well.width) * _duration) }));
		}
		public function scrub(e:MouseEvent){
			if (e.buttonDown){
				
				var offset:Number = 0;
				if (_useNubInsteadOfBar){
					offset = scrubber_nub.width / 2;
				}
				dispatchEvent(new MediaControlEvent(MediaControlEvent.SEEK, { time: Math.round(((((e.localX - offset) / _hotspotOrigWidth) * scrubber_well.width) / scrubber_well.width) * _duration) }));
				//trace("seeking: "+((((e.localX - offset) / _hotspotOrigWidth) * scrubber_well.width) / scrubber_well.width));
			
			} else {
				scrubber_hotspot.removeEventListener(MouseEvent.MOUSE_MOVE, scrub);
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
		
		public function updateScrubberPosition(time:Number){
			if (_duration != 0){
				if (_useNubInsteadOfBar){
					scrubber_nub.x = Math.min((scrubber_well.width - scrubber_nub.width) + scrubber_well.x,Math.floor(scrubber_well.x + ((time/_duration) * (scrubber_well.width - scrubber_nub.width))));
				} else {
					scrubber_nub.width = Math.min(scrubber_well.width,Math.floor(((time/_duration) * scrubber_well.width)));
				}
			}
		}
		
		public function updateLoadProgress(loadprogress:Number){
			if (isNaN(loadprogress)){
				scrubber_loadingbar.width = 0;
			} else {
				scrubber_loadingbar.width = Math.floor(loadprogress * scrubber_well.width);
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
			//scrubber_nub.visible = false;
			play_btn.visible = true;
			pause_btn.visible = false;
			_duration = 0;
			/*if (_useNubInsteadOfBar){
				scrubber_nub.x = scrubber_well.x;
				
			} else {
				scrubber_nub.width = 0;
				scrubber_nub.x = scrubber_well.x;
				
			}*/
		}
		public function durationReceived(e:MediaPlaybackEvent){
			_duration = e.args.duration;
			if (_useNubInsteadOfBar){
				scrubber_nub.x = scrubber_well.x;
				
			} else {
				scrubber_nub.width = 0;
				scrubber_nub.x = scrubber_well.x;
				
			}
			scrubber_nub.visible = true;
		}
		public function mediaSeekUpdate(e:MediaPlaybackEvent){
			
			scrubber_nub.visible = true;
			if (e.args.duration != undefined && e.args.duration != null){
				_duration = e.args.duration;
			}
			updateScrubberPosition(e.args.time);
		}
		public function loadProgress(e:MediaPlaybackEvent){
			updateLoadProgress(e.args.loadprogress);
		}
		
	}
}