// com.adam.mediaplayersFLVPlaybackWrapper
// Adam Riggs
//
package com.adam.mediaplayers {
	import flash.display.Sprite;
	import flash.events.*;
	
	import fl.video.*;
	
	import gs.TweenLite;
	
	import com.adam.utils.AppData;
	import com.adam.events.MuleEvent;
	
	public class FLVPlaybackWrapper extends Sprite {
		
		private var appData:AppData=AppData.instance;
		
		public var flvPlayback:FLVPlayback;
		public var metadata:Object;
		
		private var bufferDefault:Number;
		private var bufferPreferred:Number;
		
		public function FLVPlaybackWrapper(){
			
			init();
		}
		
//*****Initialization Routines
		
		public function init(){
			//this.visible = false;
			debug("init()");
			
			initVars();
			initFLVPlayback();
			initEvents();
		}
		
		private function initVars():void{
			//initialize the control variables
			
			bufferDefault=.1;
			bufferPreferred=3;
		}
		
		private function initEvents():void{
			//initialize all the event listeners
			debug("initEvents()");
			
			flvPlayback.addEventListener(AutoLayoutEvent.AUTO_LAYOUT, onAutoLayout);
			flvPlayback.addEventListener(VideoEvent.AUTO_REWOUND, onAutoRewound);
			flvPlayback.addEventListener(VideoEvent.BUFFERING_STATE_ENTERED, onBufferingStateEntered);
			flvPlayback.addEventListener(VideoEvent.CLOSE, onClose);
			flvPlayback.addEventListener(VideoEvent.COMPLETE, onComplete);
			flvPlayback.addEventListener(MetadataEvent.CUE_POINT, onCuePoint);
			flvPlayback.addEventListener(VideoEvent.FAST_FORWARD, onFastForward);
			flvPlayback.addEventListener(LayoutEvent.LAYOUT, onLayout);
			flvPlayback.addEventListener(MetadataEvent.METADATA_RECEIVED, onMetadataRecieved);
			flvPlayback.addEventListener(VideoEvent.PAUSED_STATE_ENTERED, onPauseStateEntered);
			flvPlayback.addEventListener(VideoEvent.PLAYHEAD_UPDATE, onPlayheadUpdate);
			flvPlayback.addEventListener(VideoEvent.PLAYING_STATE_ENTERED, onPlayingStateEntered);
			flvPlayback.addEventListener(VideoProgressEvent.PROGRESS, onProgress);
			flvPlayback.addEventListener(VideoEvent.READY, onReady);
			flvPlayback.addEventListener(VideoEvent.REWIND, onRewind);
			flvPlayback.addEventListener(VideoEvent.SCRUB_FINISH, onScrubFinish);
			flvPlayback.addEventListener(VideoEvent.SCRUB_START, onScrubStart);
			flvPlayback.addEventListener(VideoEvent.SEEKED, onSeeked);
			flvPlayback.addEventListener(SkinErrorEvent.SKIN_ERROR, onSkinError);
			flvPlayback.addEventListener(VideoEvent.SKIN_LOADED, onSkinLoaded);
			flvPlayback.addEventListener(SoundEvent.SOUND_UPDATE, onSoundUpdate);
			flvPlayback.addEventListener(VideoEvent.STATE_CHANGE, onStateChange);
			flvPlayback.addEventListener(VideoEvent.STOPPED_STATE_ENTERED, onStoppedStateEntered);
		}
		
		private function initFLVPlayback():void{
			//create the flvPlayback object
			debug("initFLVPlayback()");
			flvPlayback=new FLVPlayback();
			
			//flvPlayback.autoPlay=true;
			flvPlayback.autoRewind=true;
			//flvPlayback.source="rtmp://ec2-50-17-71-65.compute-1.amazonaws.com/vod/media/videoflv.flv";
			//flvPlayback.load("rtmp://ec2-50-17-71-65.compute-1.amazonaws.com/vod/media/sample");
			flvPlayback.bufferTime=3;
			/*flvPlayback.width=1280;
			flvPlayback.height=800;*/
			flvPlayback.width=appData.mainWidth;
			flvPlayback.height=appData.mainHeight;
			flvPlayback.scaleMode="maintainAspectRatio";
			flvPlayback.align="center";
			flvPlayback.x=flvPlayback.y=0;
			
			//smooth the video
			var videoplayer:VideoPlayer = flvPlayback.getVideoPlayer(0);
			videoplayer.smoothing = true;
			videoplayer=null;
			
			addChild(flvPlayback);
			debug("FLVPlayback.VERSION=="+FLVPlayback.VERSION);
		}
		
//*****Core Functionality
		
		private function resetSize():void{
			flvPlayback.width=appData.mainWidth;
			flvPlayback.height=appData.mainHeight;
			flvPlayback.scaleMode="maintainAspectRatio";
			flvPlayback.align="center";
			flvPlayback.x=flvPlayback.y=0;
		}
		
		public function loadSource(url:String):void{
			flvPlayback.bufferTime=.1;
			flvPlayback.source=url;
		}
		
//*****Event Handlers
		
		private function onAutoLayout(e:AutoLayoutEvent):void{
			debug("onAutoLayout oldBounds=="+e.oldBounds);
			debug("onAutoLayout oldRegistrationBounds=="+e.oldRegistrationBounds);
			debug("onAutoLayout vp=="+e.vp);
		}
		
		private function onAutoRewound(e:VideoEvent):void{
			debug("AutoRewound "+e.state);
		}
		
		private function onBufferingStateEntered(e:VideoEvent):void{
			debug("onBufferingStateEntered "+e.state);
		}
		
		private function onClose(e:VideoEvent):void{
			debug("onClose "+e.state);
		}
		
		private function onComplete(e:VideoEvent):void{
			debug("Complete "+e.state);
		}
		
		private function onCuePoint(e:MetadataEvent):void{
			//debug("CuePoint flvPlayback.playheadTime=="+flvPlayback.playheadTime);
			//debug("CuePoint time=="+e.info.time);
			
			//use appData.quads here to draw them immediately
			appData.quads.drawQuad(e.info);
			//appData.eventManager.dispatch("wishlist", {type:"addInscene", product:appData.database.getProductById(e.info.annotid)});
			/*if(appData.database.uniqueVidAnnotationsArray[0]==e.info.annotid){
				appData.main.inscene.addToList(appData.database.getProductFromAnnotationId(appData.database.uniqueVidAnnotationsArray.shift()));
			}*/
			var idx:int=appData.database.uniqueVidAnnotationsArray.indexOf(e.info.annotid);
			//debug("e.info.annotid=="+e.info.annotid);
			//debug("idx=="+idx);
			if(idx!=-1){
				appData.main.inscene.addToList(appData.database.getProductFromAnnotationId(e.info.annotid));
				appData.database.uniqueVidAnnotationsArray.splice(idx,1);
			}
		}
		
		private function onFastForward(e:VideoEvent):void{
			debug("onFastForward "+e.state);
		}
		
		private function onLayout(e:LayoutEvent):void{
			debug("onLayout "+e.oldBounds);
			debug("flvPlayback.width=="+flvPlayback.width);
			debug("flvPlayback.height=="+flvPlayback.height);
			debug("flvPlayback.x=="+flvPlayback.x);
			debug("flvPlayback.y=="+flvPlayback.y);
		}
		
		private function onMetadataRecieved(e:MetadataEvent):void{
			debug("onMetadataRecieved "+e.info);
			
			debug("flvPlayback.bufferTime=="+flvPlayback.bufferTime);
			
			//metadata=e.info;
			/*debug("e.info:");
			var key:String;
			for (key in e.info){
					debug("\t"+key + ": " + e.info[key]);
			}
			debug("e.vp=="+e.vp);
			debug("*****");
			debug("flvPlayback.metadata:");
			for (key in flvPlayback.metadata){
					debug("\t"+key + ": " + flvPlayback.metadata[key]);
			}*/
			/*debug("*****");
			debug("e:"+e);
			for (key in e){
					debug("\t"+key + ": " + e[key]);
			}*/
			
			//debug("appData.mainWidth/metadata.width=="+appData.mainWidth+"/"+metadata.width+"="+(appData.mainWidth/metadata.width));
			//debug("appData.mainHeight/metadata.height=="+appData.mainHeight+"/"+metadata.height+"="+(appData.mainHeight/metadata.height));
			//appData.videoplayer.metaData(e.info);
			//appData.eventManager.dispatch("videoplayer", {type:"metadata", sender:"FLVPlaybackWrapper", event:e});
			
			//flvPlayback.bufferTime=bufferPreferred;
			
		}
		
		private function onPauseStateEntered(e:VideoEvent):void{
			debug("onPauseStateEntered "+e.state);
			//appData.quads.videoPaused();
		}
		
		private function onPlayheadUpdate(e:VideoEvent):void{
			//debug("onPlayheadUpdate "+e.state);
		}
		
		private function onPlayingStateEntered(e:VideoEvent):void{
			debug("onPlayingStateEntered "+e.state);
			//appData.quads.videoPlayed();
		}
		
		private function onProgress(e:VideoProgressEvent):void{
			debug("onProgress "+e.bytesLoaded+"/"+e.bytesTotal);
		}
		
		private function onReady(e:VideoEvent):void{
			debug("onReady "+e.state);
			appData.eventManager.dispatch("videoplayer", {type:"ready", sender:"FLVPlaybackWrapper", event:e});
			var key:String;
			for (key in flvPlayback.metadata){
					debug("\t"+key + ": " + flvPlayback.metadata[key]);
			}
			metadata=flvPlayback.metadata;
			flvPlayback.bufferTime=bufferPreferred;
			debug("flvPlayback.bufferTime=="+flvPlayback.bufferTime);
			appData.eventManager.dispatch("videoplayer", {type:"metadata", sender:"FLVPlaybackWrapper"});
		}
		
		private function onRewind(e:VideoEvent):void{
			debug("onRewind "+e.state);
		}
		
		private function onScrubFinish(e:VideoEvent):void{
			debug("onScrubFinish "+e.state);
		}
		
		private function onScrubStart(e:VideoEvent):void{
			debug("onScrubStart "+e.state);
		}
		
		private function onSeeked(e:VideoEvent):void{
			debug("onSeeked "+e.state);
		}
		
		private function onSkinError(e:SkinErrorEvent):void{
			debug("onSkinError "+e.text);
		}
		
		private function onSkinLoaded(e:VideoEvent):void{
			debug("onSkinLoaded "+e.state);
		}
		
		private function onSoundUpdate(e:SoundEvent):void{
			debug("onSoundUpdate "+e.soundTransform);
		}
		
		private function onStateChange(e:VideoEvent):void{
			debug("onStateChange "+e.state);
			
			switch(e.state){
				
				case "playing":
					appData.eventManager.dispatch("videoplayer", {type:"playing", sender:"FLVPlaybackWrapper"});
					appData.quads.videoPlaying();
					appData.videoplayer.hideLoading();
				break;
				
				case "paused":
					appData.quads.videoPaused();
				break;
				
				case "loading":
					appData.videoplayer.showLoading();
					//resetSize();
				break;
				
				case "buffering":
					appData.videoplayer.showLoading();
				break;
				
				case "stopped":
					
				break;
				
			}
		}
		
		private function onStoppedStateEntered(e:VideoEvent):void{
			debug("onStoppedStateEntered "+e.state);
		}
		
		
		
//*****Gets and Sets
		
		
		
//*****Utility Functions
		
		//**visibility
		public function show(){
			this.visible = true;
		}
		
		public function hide(){
			this.visible = false;
		}
		
		//**debug
		private function debug(str:String):void{
			trace(str);
			appData.eventManager.dispatch("debug", {msg:str, sender:"FLVPlaybackWrapper"});
		}
		
	
	}//end class
}//end package