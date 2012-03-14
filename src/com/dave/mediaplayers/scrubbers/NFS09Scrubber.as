// VolumeScrubber.as
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
//
//	This class defines a scrubber's functionality and manages its assets.
//
package com.dave.mediaplayers.scrubbers {

	import com.dave.mediaplayers.Scrubber;
	import com.dave.mediaplayers.scrubbers.VolumeScrubber;
	import com.dave.mediaplayers.events.*;
	import flash.events.*;
	import com.dave.events.*;
	import flash.display.MovieClip;
	import com.app.Application;
	import com.dave.utils.GetURL;
	

	public class NFS09Scrubber extends VolumeScrubber {
		//public var volume_well, volume_nub, volume_hotspot, volume_speaker:MovieClip;
		//public var _volumeHotspotOrigWidth:Number;
		public var back_btn,mail_btn:MovieClip;
		
		public function NFS09Scrubber(xPos:int, yPos:int, totalWidth:int, leftIndent:int, rightIndent:int, wellIndent:int, showPlayPauseButton:Boolean, showStopButton:Boolean, showRewindButton:Boolean, useNubInsteadOfBar:Boolean, volume_well_x:int, volume_well_width:int){
			super(xPos, yPos, totalWidth, leftIndent, rightIndent, wellIndent, showPlayPauseButton, showStopButton, showRewindButton, useNubInsteadOfBar, volume_well_x, volume_well_width);
		
			initNFSScrubber();
		}
		
		public function initNFSScrubber(){
			
			back_btn.buttonMode = true;
			back_btn.addEventListener(MouseEvent.CLICK, back_btn_click);
			
			mail_btn.buttonMode = true;
			mail_btn.addEventListener(MouseEvent.CLICK, mail_btn_click);

			this.addEventListener(MediaControlEvent.MUTE, muteHandler);
		}
		
		public function muteHandler(e:MediaControlEvent){
			if (e.args.mute){
				Application.soundManager.mute();
			} else {
				Application.soundManager.unmute();
			}
		}
		
		public function back_btn_click(e:MouseEvent)
		{
			EventCenter.broadcast("onRoomNav", { destination: "main_loop" });
		}
		
		public function mail_btn_click(e:MouseEvent)
		{
			var url = new GetURL(Application.urls.mailafriend);
		}
		public function resizeHandler(){
			this.x = Application.contentArea.x + Math.floor(Application.contentArea.width/2 - this.width/2);
			this.y = Application.contentArea.y + Application.contentArea.height - 40;
			
			//this.x = Math.floor(stage.width/2 - this.width/2);
			//this.y = stage.height - 40;
		}
		
		
	}
}