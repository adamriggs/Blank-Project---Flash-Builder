
// com.adam.utils.Bandwidth
// Adam Riggs
//
package com.adam.utils {
	//import flash.display.Sprite;
	//import flash.events.*;
	
	//import gs.TweenMax;
	
	//import com.adam.utils.AppData;
	//import com.adam.events.MuleEvent;
	//import com.adam.utils.Bandwidth_Progress;
	
	public class Bandwidth{
		
		//public var progressArray:Array;
		public var startTime:Date;
		public var endTime:Date;
		public var totalBytes:Number;
		public var speed:Number;
		public var time:Number;
		/*public var min:Number;
		public var max:Number;
		public var mean:Number;
		public var median:Number;
		public var mode:Number;*/
		
		public function Bandwidth(){
			init();
		}
		
//*****Initialization Routines
		
		public function init():void{
			//this.visible = false;
			trace("Bandwidth() init");
			//progressArray=new Array();
		}
		
//*****Core Functionality
		
		public function calcBandwidth():void{
			
			//trace("bandwidth.startTime="+startTime.getTime());
			
			time=(endTime.getTime()-startTime.getTime())/1000;
			speed=totalBytes/1024/time;
			
			trace("speed=="+speed);
			
		}
		
		
//*****Event Handlers
		
		/*private function onProgress(e:ProgressEvent):void{
			
		}
		
		private function onComplete(e:Event):void{
			
		}*/
		
		
//*****Gets and Sets
		
		//private function get progressArray():Array{return _progressArray};
		
		/*public function get startTime():Date{return _startTime;}
		public function set startTime(value:Date):void{_startTime=value;}
		
		public function get average():Number{return _average;}
		
		public function get min():Number{return _min;}
		
		public function get max():Number{return _max;}
		
		public function get mean():Number{return _mean;}
		
		public function get median():Number{return _median;}
		
		public function get mode():Number{return _mode;}*/
		
		
		
//*****Utility Functions
	
	}
}