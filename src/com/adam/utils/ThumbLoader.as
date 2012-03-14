// com.app.ThumbLoader
// Adam Riggs
//
package com.app {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.*;
	import caurina.transitions.*;
	
	import com.dave.utils.DaveTimer;
	import com.dave.events.*;
	
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import com.dave.mediaplayers.SimpleVideoPlayer;
	import com.dave.mediaplayers.events.MediaPlaybackEvent;
	
	public class ThumbLoader extends Sprite {
		
		//thumbnail data
		private var thumbLoader:Loader;
		public var thumbBM:Bitmap;
		private var thumbBMW:int;
		private var thumbBMH:int;
		private var thumbName:String;
		private var thumbVid:SimpleVideoPlayer;
		private var path:String;
		public var id:String;
		
		//tweener data
		private var transTime;
		private var transType;
		
		//progress bar variables
		private var progressBar:Sprite;
		private var progressW:int;
		private var progressH:int;
		private var progressFill:int;
		private var progressBkg:int;
		
		public var loadingStatus:String;
		
		public function ThumbLoader(){
			
			//thumbName=t;
			init();
		}
		
//*****Initalization Functions
		
		public function init(){
			//this.visible = false;
			//trace("ThumbLoader() init");
			EventCenter.subscribe("onNav",onNav);
		
		
			//DaveTimer.wait(200,lateInit);
			
			initParams();
			initBitmap();
			//initProgressBar();
			//loadThumb(thumbName);
		}
		
		private function initParams():void{
			transTime=.25;
			transType="linear";
			
			loadingStatus="init";
			
			progressW=100;
			progressH=3;
			progressFill=0x333333;
			progressBkg=0xCCCCCC;
		}
		
		private function initBitmap():void{
			thumbBM=new Bitmap();
			addChild(thumbBM);
		}
		
		private function initProgressBar():void{
			//progressBar should really be it's own class.
			progressBar=new Sprite();
			progressBar.graphics.lineStyle(progressH,progressBkg);
			progressBar.graphics.moveTo(0, 0);
			progressBar.graphics.lineTo(progressW, 0);
			addChild(progressBar);
			
			progressBar.graphics.moveTo(0, 0);
		}
		
//*****Core Functionality

		private function parsePath(s:String):void{
			var i:uint=thumbName.indexOf(".");
			path=thumbName.substr(i+1, 3);
		}
		
		private function setWH(w:int, h:int):void{
			thumbBMW=w;
			thumbBMH=h;
			progressBar.x=(w-progressW)/2;
			progressBar.y=(h-progressH)/2;
		}
		
		public function loadThumb(t:String, w:int, h:int):void{
			trace("ThumbLoader loadThumb "+t);
			
			loadingStatus="loading";
			
			thumbName=t;
			parsePath(thumbName);
			
			initProgressBar();
			
			setWH(w,h);
			
			progressBar.alpha=1;
			
			removeChild(thumbBM);
			
			thumbLoader=new Loader();
			thumbLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			thumbLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			
			switch(path){
				case "jpg":
					thumbLoader.load(new URLRequest(Application.paths.jpg+thumbName));
				break;
				
				case "png":
					thumbLoader.load(new URLRequest(Application.paths.png+thumbName));
				break;
				
				case "flv":
					thumbLoader.load(new URLRequest(Application.paths.jpg+"frame_small.jpg"));
					
					thumbVid=new SimpleVideoPlayer(0,0,340,193,true,1,Application.netConnection,this);
					thumbVid.playVideo(Application.paths.flv+thumbName);
					thumbVid.addEventListener(MediaPlaybackEvent.STOPPED, onVideoStopped);
					thumbVid.x=1;
					thumbVid.y=1;
					addChild(thumbVid);
					
				break;
				
			}
						
		}
		
		private function removeProgress():void{
			progressBar.graphics.clear();
			removeChild(progressBar);
			progressBar=null;
		}
		
//*****Event Handlers
		
		private function onProgress(e:ProgressEvent):void{
			//progressBar should really be it's own class
			progressBar.graphics.lineStyle(progressH,progressFill);
			progressBar.graphics.lineTo((progressW*e.bytesLoaded)/e.bytesTotal, 0);
		}
		
		private function onComplete(e:Event):void{
			trace("ThumbLoader thumb loaded");
			
			loadingStatus="finished";
			
			//progressBar should really be it's own class
			progressBar.graphics.moveTo(0, 0);
			progressBar.graphics.lineStyle(progressH,progressFill);
			progressBar.graphics.lineTo(progressW, 0);
			
			thumbBM=new Bitmap();
			thumbBM=Bitmap(e.target.content);
			thumbBM.smoothing=true;
			thumbBM.alpha=0;
			addChildAt(thumbBM,0);
			
			//Tweener.addTween(progressBar, {alpha:0, time:transTime, transition:transType, onComplete:removeProgress});
			progressBar.alpha=0;
			removeProgress();
			Tweener.addTween(thumbBM, {alpha:1, time:transTime, transition:transType});
			
			thumbLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			thumbLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			
			EventCenter.broadcast("onThumbLoader", {status:loadingStatus, file:thumbName});
		}
		
		public function onNav(e:ApplicationEvent){
			//trace("GenericObject.onNav - "+e.args.destination);
			
		}
		
		private function onVideoStopped(e:MediaPlaybackEvent):void{
			thumbVid.repeatVideo();
		}
		
		
		
//*****Utility Functions

			
		public function lateInit(e:Event){
			
		}
		
		
		
		public function resizeHandler(){
			
		}
		
		public function show(){
			this.visible = true;
		}
		
		public function hide(){
			this.visible = false;
		}
		
	
	}
}