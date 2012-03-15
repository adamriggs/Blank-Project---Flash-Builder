// com.app.ThumbLoader
// Adam Riggs
//
package com.adam.utils {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.*;
	import caurina.transitions.*;
	
	import com.adam.utils.AppData;
	import com.adam.events.MuleEvent;
	
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.system.LoaderContext;
	
	public class ThumbLoader extends Sprite {
		
		private var appData:AppData=AppData.instance;
		
		//thumbnail data
		private var thumbLoader:Loader;
		public var thumbBM:Bitmap;
		private var thumbBMW:int;
		private var thumbBMH:int;
		private var thumbName:String;
		private var path:String;
		public var id:String;
		private var scale:Number;
		
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
			
			initVars();
			initBitmap();
			//initProgressBar();
			//loadThumb(thumbName);
		}
		
		private function initVars():void{
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
		
		private function setWH(w:int, h:int):void{
			thumbBMW=w;
			thumbBMH=h;
			progressBar.x=(w-progressW)/2;
			progressBar.y=(h-progressH)/2;
		}
		
		public function loadThumb(t:String, w:int=125, h:int=125):void{
			trace("ThumbLoader loadThumb "+t);
			
			loadingStatus="loading";
			
			path=t;
			initProgressBar();
			thumbBMW=w;
			thumbBMH=h;
			setWH(w,h);
			progressBar.alpha=1;
			
			removeChild(thumbBM);
			
			thumbLoader=new Loader();
			thumbLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			thumbLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTP);
			thumbLoader.contentLoaderInfo.addEventListener(Event.INIT, onInit);
			thumbLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			thumbLoader.contentLoaderInfo.addEventListener(Event.OPEN, onOpen);
			thumbLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			thumbLoader.contentLoaderInfo.addEventListener(Event.UNLOAD, onPicUnload);
			
			var loaderContext=new LoaderContext();
			loaderContext.checkPolicyFile=true;
			
			thumbLoader.load(new URLRequest(path),loaderContext);
			
		}
		
		private function removeProgress():void{
			progressBar.graphics.clear();
			removeChild(progressBar);
			progressBar=null;
		}
		
//*****Event Handlers
		
		private function onHTTP(e:HTTPStatusEvent):void{
			//debug("HTTP_STATUS e.status=="+e.status);
		}
		
		private function onInit(e:Event):void{
			//debug("INIT");
		}
		
		private function onIOError(e:IOErrorEvent):void{
			//debug("IO_ERROR e.text=="+e.text);
		}
		
		private function onOpen(e:Event):void{
			//debug("OPEN");
		}
		
		private function onPicUnload(e:Event):void{
			//debug("UNLOAD");
		}
		
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
			thumbBM.alpha=1;
			/*thumbBM.width=thumbBMW;
			thumbBM.height=thumbBMH;*/
			
			//scale the image while maintaining aspect ratio
			if(thumbBM.width>thumbBM.height){
				//if the image is wider than it is tall
				scale=(thumbBMW/thumbBM.width);
			} else {
				//if the image is taller than it is wide
				scale=(thumbBMH/thumbBM.height);
			}
			thumbBM.scaleX=scale;
			thumbBM.scaleY=scale;
			
			addChildAt(thumbBM,0);
			
			//Tweener.addTween(progressBar, {alpha:0, time:transTime, transition:transType, onComplete:removeProgress});
			progressBar.alpha=0;
			removeProgress();
			//Tweener.addTween(thumbBM, {alpha:1, time:transTime, transition:transType});
			
			thumbLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			thumbLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			
			appData.eventManager.dispatch("onThumbLoader", {status:loadingStatus, file:thumbName});
		}
		
		
//*****Utility Functions
		
		public function show(){
			this.visible = true;
		}
		
		public function hide(){
			this.visible = false;
		}
		
		//**debug
		private function debug(str:String):void{
			trace(str);
			appData.eventManager.dispatch("debug", {msg:str, sender:"ThumbLoader"});
		}
		
	
	}
}