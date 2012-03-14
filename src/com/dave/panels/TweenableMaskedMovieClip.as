/*
// com.dave.panels.TweenableMaskedMovieClip
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
//
//	Behaves just like any other movie clip, but you define a masked region that bounds the clip.  The clip also contains some methods
//  for tweening the size of that mask.  You add children to this.inner.
//
*/

package com.dave.panels {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import caurina.transitions.*;
	
	public class TweenableMaskedMovieClip extends MovieClip {
		
		public var copymask:Sprite;
		public var inner:MovieClip;
		
		public var _innerWidth:Number;
		public var _innerHeight:Number;
		
		private var myRect:Rectangle;
		
		public function TweenableMaskedMovieClip(innerWidth:Number=0, innerHeight:Number=0){

			_innerWidth = innerWidth;
			_innerHeight = innerHeight;
			
			inner = new MovieClip();
			addChild(inner);
			
			resetMask();
			
			
			
			
		}
		
		public function tweenMask(newWidth:Number, newHeight:Number, transtime:Number, transitiontype:String="easeInOutQuad", completed:Function=null):void{
			trace("TweenableMaskedMovieClip.tweenMask("+newWidth+", "+newHeight+", "+transtime+", "+transitiontype+", "+completed+")");
			if (completed == null){
				Tweener.addTween(copymask, { width: newWidth, height: newHeight, time: transtime, transition: transitiontype });
			} else {
				Tweener.addTween(copymask, { width: newWidth, height: newHeight, time: transtime, transition: transitiontype, onComplete:completed });
			}
			
			_innerWidth = newWidth;
			_innerHeight = newHeight;
		}
		
		public function setMaskSize(innerWidth, innerHeight):void{
			_innerWidth = innerWidth;
			_innerHeight = innerHeight;
			copymask.width = _innerWidth;
			copymask.height = _innerHeight;
			resetMask();
		}
		
		private function resetMask():void{
			try {
				removeChild(copymask);
			} catch (e:Error){
				
			} finally {
				copymask = new Sprite();
			}
			
			addChild(copymask);
			copymask.graphics.lineStyle(0);
			copymask.graphics.beginFill(0x666666,1);
			copymask.graphics.drawRect(0,0,10,10);
			copymask.width = _innerWidth;
			copymask.height = _innerHeight;
			
			this.inner.mask = copymask;
		}
		
	}
}