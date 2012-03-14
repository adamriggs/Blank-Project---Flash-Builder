// com.dave.ChromeTimeCounter
// Dave Cole
//
//	Represents an embed button for a given media player.
// 
// Expected Skin Elements:
//	btn			- Embed button icon
//	btn_roll	- Embed Screen button roll-over state
//
// Inherited functions:
//	show();
//	hide();
//	all other functions are overridden below.
//
package com.dave.mediaplayers.chrome {
	import com.dave.events.*;
	import com.dave.mediaplayers.chrome.events.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	
	public class ChromeTimeCounter extends Chrome {
		public var inner:ChromeTimeCounterAsset;
		public var bkg:MovieClip;
		public var time:TextField;
		private var currentTime:Number;
		private var duration:Number;
		
		public function ChromeTimeCounter(initObj:Object){
			super(initObj);
			init();
		}
		
		public function init():void{
			//this.visible = false;
			trace("ChromeTimeCounter() init");
			inner = new ChromeTimeCounterAsset();
			addChild(inner);
			bkg = inner.bkg;
			time = inner.time;
			
			EventCenter.subscribe("onVideoClose", onVideoClose);  // *** custom
			
			duration = 0;
			currentTime = 0;
			time.text = "";
			
		}
		
		public override function lateInit(e:Event):void{
			
		}
		
		protected override function onPlaybackEvent(e:ChromeEvent):void{
			trace("ChromeTimeCounter.onPlaybackEvent "+e.args+" "+e.args.type+" "+e.args.time+" "+e.args.duration);
			if (e.args.type == "duration"){
				duration = Math.floor(e.args.duration);
				if (duration == 0){
					time.text = "";
				} else {
					time.text = convertTime(currentTime) + " / " + convertTime(duration);
				}
			} else if (e.args.type == "headposition") {
				currentTime = Math.round(e.args.time);
				duration = Math.floor(e.args.duration);
				if (duration == 0){
					time.text = "";
				} else {
					time.text = convertTime(currentTime) + " / " + convertTime(duration);
				}
			} else if (e.args.type == "unstarted"){
				time.text = "";
			}
			
		}
		
		/*
		private function convertTime(t:Number):String{
			var minutes:Number;
			var minutesStr:String;
			var hours:Number;
			var seconds:Number;
			var secondsStr:String;
			if (t < 60){
				// seconds
				secondsStr = String(t);
				if (secondsStr.length == 1){
					secondsStr = "0" + secondsStr;
				} 
				return("00:"+secondsStr);
			} else if (t < 3600){
				// minutes and seconds
				minutes = Math.floor(t/60);
				seconds = t % 60;
				minutesStr = String(minutes);
				secondsStr = String(seconds);
				if (minutesStr.length == 1){
					minutesStr = "0" + minutesStr;
				} 
				if (secondsStr.length == 1){
					secondsStr = "0" + secondsStr;
				} 
				return(minutesStr+":"+secondsStr);
			} else {
				// hours, minutes and seconds
				hours = Math.floor(t/3600);
				minutes = t - (hours * 3600);
				seconds = t % 3600;
				minutesStr = String(minutes);
				secondsStr = String(seconds);
				if (minutesStr.length == 1){
					minutesStr = "0" + minutesStr;
				} 
				if (secondsStr.length == 1){
					secondsStr = "0" + secondsStr;
				} 
				return(String(hours)+":"+minutesStr+":"+secondsStr);
			}
		}
		*/
		
		private function convertTime(secs:Number):String {
			var s:Number = secs % 60;
			var m:Number = Math.floor((secs % 3600 ) /60);
			var h:Number = Math.floor(secs / (60*60));
			
			var hourstring:String = h<10 ? "0"+h+":" : h+":";
			if (h==0) hourstring="";
			var minutestring:String = m<10 ? "0"+m+":" : m+":";
			var secstring:String = String(s<10 ? "0"+s : s);
			
			
			return(hourstring+minutestring+secstring);
			
		}
		
		private function onVideoClose(e:ApplicationEvent):void{
			time.text = "";
		}
		
	}
}