// Scrubber.as
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
//
//	This class defines a scrubber's functionality and manages its assets.
//
package com.dave.mediaplayers.scrubbers {

	import com.dave.mediaplayers.Scrubber;
	
	public class FranksScrubber extends Scrubber {
		public function FranksScrubber(xPos:int, yPos:int, totalWidth:int, leftIndent:int, rightIndent:int, wellIndent:int, showPlayPauseButton:Boolean, showStopButton:Boolean, showRewindButton:Boolean, useNubInsteadOfBar:Boolean){
			super(xPos, yPos, totalWidth, leftIndent, rightIndent, wellIndent, showPlayPauseButton, showStopButton, showRewindButton, useNubInsteadOfBar);
		}
		

	}
}