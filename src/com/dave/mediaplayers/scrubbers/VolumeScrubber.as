// VolumeScrubber.as
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
//
//
//  License: Only Dave Cole and active Mekanism employees or contractors may use this code.
//
//	This class defines a scrubber's functionality and manages its assets.
//
package com.dave.mediaplayers.scrubbers {

	import com.dave.mediaplayers.Scrubber;
	import com.dave.mediaplayers.events.*;
	import flash.events.*;
	import flash.display.MovieClip;
	

	public class VolumeScrubber extends Scrubber {
		public var volume_well, volume_nub, volume_hotspot, volume_speaker:MovieClip;
		public var _volumeHotspotOrigWidth:Number;
		
		public function VolumeScrubber(xPos:int, yPos:int, totalWidth:int, leftIndent:int, rightIndent:int, wellIndent:int, showPlayPauseButton:Boolean, showStopButton:Boolean, showRewindButton:Boolean, useNubInsteadOfBar:Boolean, volume_well_x:int, volume_well_width:int){
			super(xPos, yPos, totalWidth, leftIndent, rightIndent, wellIndent, showPlayPauseButton, showStopButton, showRewindButton, useNubInsteadOfBar, volume_well_x, volume_well_width);
		
			volume_nub.useHandCursor = volume_nub.buttonMode = true;
			
			initVolume(volume_well_x,volume_well_width);
		}
		
		public function initVolume(volume_well_x:int,volume_well_width:int){
			_volumeHotspotOrigWidth = volume_hotspot.width;
			
			volume_well.x = volume_well_x;
			volume_hotspot.x = volume_well_x - 0;
			volume_speaker.x = volume_well.x - volume_speaker.width - 5;
			volume_well.width = volume_well_width;
			volume_hotspot.width = volume_well_width + 0;
			volume_nub.x = volume_well.x + volume_well.width - (volume_nub.width / 2);
			
			
			volume_hotspot.addEventListener(MouseEvent.MOUSE_DOWN, volume_hotspot_mouseDown);
			volume_hotspot.addEventListener(MouseEvent.MOUSE_UP, volume_hotspot_mouseUp);
			
			volume_speaker.buttonMode = true;
			volume_speaker.speaker_off.visible = false;
			volume_speaker.addEventListener(MouseEvent.CLICK, volume_speaker_click);
		}
		
		public function volume_speaker_click(e:MouseEvent){
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
		
		public function volume_hotspot_mouseDown(e:MouseEvent){
			var offset:Number = 0;
				
			offset = volume_nub.width / 2;
				
			//trace("e.localX = "+e.localX+"  offset="+offset+"   _volumeHotspotOrigWidth="+_volumeHotspotOrigWidth+"   volume.well.width="+volume_well.width);
			volume_nub.x = volume_well.x + (((e.localX - offset) / _volumeHotspotOrigWidth) * volume_well.width);
			//trace("setting volume: "+Math.min(1,(Math.max(0,(((((e.localX) / _volumeHotspotOrigWidth) * volume_well.width) / volume_well.width))))));
			dispatchEvent(new MediaControlEvent(MediaControlEvent.VOLUME, { volumenum: Math.min(1,(Math.max(0,Math.round((((e.localX) / _volumeHotspotOrigWidth) * volume_well.width) / volume_well.width)))) }));
			
			volume_hotspot.addEventListener(MouseEvent.MOUSE_MOVE, scrubVolume);
		}
		public function volume_hotspot_mouseUp(e:Event){
			volume_hotspot.removeEventListener(MouseEvent.MOUSE_MOVE, scrubVolume);
		}
		public function scrubVolume(e:MouseEvent){
			if (e.buttonDown){
				
				var offset:Number = 0;
				
				offset = volume_nub.width / 2;
				
				//trace("e.localX = "+e.localX+"  offset="+offset+"   _volumeHotspotOrigWidth="+_volumeHotspotOrigWidth+"   volume.well.width="+volume_well.width);
				volume_nub.x = volume_well.x + (((e.localX - offset) / _volumeHotspotOrigWidth) * volume_well.width);
				//trace("setting volume: "+Math.min(1,(Math.max(0,(((((e.localX) / _volumeHotspotOrigWidth) * volume_well.width) / volume_well.width))))));
				dispatchEvent(new MediaControlEvent(MediaControlEvent.VOLUME, { volumenum: Math.min(1,(Math.max(0,((((e.localX) / _volumeHotspotOrigWidth) * volume_well.width) / volume_well.width)))) }));
			} else {
				volume_hotspot.removeEventListener(MouseEvent.MOUSE_MOVE, scrub);
			}
			
		}

	}
}