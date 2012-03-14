// Fps.as
// AS3
// Dave Cole


package com.dave.utils {
	import com.app.Application;
	import flash.display.*;
	import flash.events.*
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import com.dave.events.*;
	
	public class Fps extends Sprite {
		
		private var elapsedFrames:Number;
		private var frameTime:Number;
		private var elapsedFPS:Number;
		private var startFPS:Number;
		private var fpsField:TextField;
		private var bkgBox:Sprite;
		private var timer:Timer;
		private var showFPS:Boolean;
		public var runningAverage:Number;
		private var ticks:int;

		
		public function Fps(makeVisible:Boolean=true,tColor:Number=0x000000){
			elapsedFrames 	= 0;
			elapsedFPS 		= 0;
			startFPS 		= 0;
			runningAverage  = 0;
			showFPS = makeVisible;
			ticks = 0;
			
			//if (showFPS){
				bkgBox = new Sprite();
				bkgBox.graphics.lineStyle(0);
				bkgBox.graphics.beginFill(0xAAAAAA,1);
				bkgBox.graphics.drawRect(0,0,380, 23);
				addChild(bkgBox);
				
				fpsField = new TextField();
				fpsField.y = 2;
				fpsField.x = 5;
				fpsField.width = 380;
				fpsField.height = 30;
				addChild(fpsField);
				
				var tFormat:TextFormat = new TextFormat();
				tFormat.font = "Arial";
				tFormat.color = tColor;
			
				fpsField.setTextFormat(tFormat);
				fpsField.text = 'fps';
			//}
			
			if (showFPS){
				this.visible = true;
			} else {
				this.visible = false;
			}
			
			if (stage != null){
				stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKey);
			}
			
			timer = new Timer(1000,0);
			timer.addEventListener(TimerEvent.TIMER, myDisplay);
			timer.start();
			
			addEventListener(Event.ENTER_FRAME, myEnterFrame);
		}
		
		public function lateInit():void{
			try { 
				stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKey);
			} catch (e:Error){
				
			} finally { 
			
			}
		}
		
		public function myDisplay(e:TimerEvent):void{
		
			if (showFPS){
				fpsField.text = 'fps: ' + elapsedFrames + ', avg fps: ' + runningAverage + ', bandwidth: '+ Application.bandwidth + ', quality: '+ Application.quality + ', video smoothing: '+Application._smoothing;
			}
			
			if (runningAverage == 0){
				runningAverage = elapsedFrames;
			} else {
				runningAverage = Math.floor(((runningAverage * 3) + elapsedFrames)/4);
			}
			
			++ticks;
			performanceCheck();
			
			elapsedFrames = 0;
		}
		
		
		private function performanceCheck():void{
			// Do any application-specific performance metrics & decision making here.
			if (ticks >= 5){
				if (runningAverage <= 10 && Application._smoothing){
					Application.setSmoothing(false);
					trace("***** Framerate too low - killing video smoothing");
				} /*else if (runningAverage >= 22 && !Application._smoothing){
					Application.setSmoothing(true);
					trace("***** Framerate too high - enabling video smoothing");
				}*/
			}
			/*
			if (ticks > 8){
				if (runningAverage <= 5){
					EventCenter.broadcast("onBandwidthWarn",{});
				}
			}
			*/
			if (ticks == 10){
				EventCenter.broadcast("onTrackingEvent", { arg:"UserFPS" , eventName: runningAverage });
				EventCenter.broadcast("onTrackingEvent", { arg:"UserVideoSmoothing" , eventName: Application._smoothing});
			}
		}
		
		
		private function myEnterFrame(e:Event):void{
			this.elapsedFrames++;
		}
		
		public function checkKey(e:KeyboardEvent):void{
			trace("key pressed "+e.keyCode);
			if (e.keyCode == Keyboard.CONTROL && e.shiftKey){
				if (showFPS){
					showFPS = false;
					this.visible = false;
				} else {
					showFPS = true;
					this.visible = true;
				}
			}
		}
		
		public function kill():void{
			removeEventListener(Event.ENTER_FRAME, myEnterFrame);
			try { 
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKey);
			} catch (e:Error){
				
			} finally { 
			
			}
			timer.stop();
		}
		
		
		
	}
}
