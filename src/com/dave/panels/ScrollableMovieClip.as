/*
// com.dave.panels.ScrollableMovieClip
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
//
//	Behaves just like any other movie clip, but you define a masked region that, if the inner content extends beyond, scrollbars will appear
//  allowing the user to scroll within the content.  You add children to this.inner.
//
//  Also has some tweening methods:
*/

package com.dave.panels {
	import com.dave.panels.ScrollableMovieClipAsset;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	public class ScrollableMovieClip extends MovieClip {
		public var asset:ScrollableMovieClipAsset;
		public var copymask:Sprite;
		public var scrollnub:MovieClip;
		public var scrollwell:MovieClip;
		public var scroll_ctr:MovieClip;
		public var upArrow:SimpleButton;
		public var dnArrow:SimpleButton;
		public var inner:MovieClip;
		
		private var _innerWidth:Number;
		private var _innerHeight:Number;
		
		private var myRect:Rectangle;
		
		public function ScrollableMovieClip(innerWidth:Number, innerHeight:Number):void{

			_innerWidth = innerWidth;
			_innerHeight = innerHeight;
			
			asset = new ScrollableMovieClipAsset();
			addChild(asset);
			scrollnub = asset.scrollnub;
			scroll_ctr = asset.scroll_ctr;
			upArrow = asset.upArrow;
			dnArrow = asset.dnArrow;
			scrollwell = asset.scrollwell;
			
			if (scroll_ctr == null){
				scroll_ctr = new MovieClip();
			}
			
			copymask = new Sprite();
			addChild(copymask);
			copymask.graphics.lineStyle(0);
			copymask.graphics.beginFill(0x666666,1);
			copymask.graphics.drawRect(0,0,_innerWidth, _innerHeight);
			
			inner = new MovieClip();
			addChild(inner);
			
			scrollnub.useHandCursor = scrollnub.buttonMode = true;
			
			scrollnub.y = inner.y = 0;
			inner.x = 0;
			
			this.inner.mask = copymask;
			scrollwell.alpha = 0.5;
			
			updateScroller();
		}
		
		
		
		
		
		public function updateScroller():void{
			if (this.inner.height <= this.copymask.height){
				this.scrollnub.visible = false;
				this.scrollwell.visible = false;
				this.scroll_ctr.visible = false;
				inner.removeEventListener(Event.ENTER_FRAME, inner_onEnterFrame);
				
			} else {
				this.scrollnub.visible = true;
				this.scrollwell.visible = true;
				this.scroll_ctr.visible = true;
			
				this.scrollnub.x = this.copymask.width + 5;
				this.scrollnub.y = 0;
				this.scrollwell.x = this.copymask.width + 5;
				this.scrollwell.y = 0;
				this.scrollwell.height = this.copymask.height;
				this.scroll_ctr.x = this.scrollnub.x + 1;
				
				this.upArrow.width = this.dnArrow.width = this.scrollwell.width - 2;
				this.upArrow.x = this.scrollwell.x;
				this.dnArrow.x = this.scrollwell.x;
				this.upArrow.y = 0;
				this.dnArrow.y = this.scrollwell.height - this.dnArrow.height + 7;
				
				var scrollAmount:Number = (this.inner.height/this.copymask.height);
				
				this.scrollnub.middle.height = this.copymask.height/scrollAmount - (this.scrollnub.top.height + this.scrollnub.bottom.height);
				this.scrollnub.middle.y = this.scrollnub.top.height;
				this.scrollnub.bottom.y = this.scrollnub.middle.y + this.scrollnub.middle.height;
				//this.scrollnub.height = this.copymask.height/scrollAmount;
						
				this.scroll_ctr.y = this.scrollnub.y + (this.scrollnub.height/2) - (this.scroll_ctr.height/2);
				
				scrollnub.addEventListener(MouseEvent.MOUSE_DOWN, scrollnub_onPress);
				scrollnub.addEventListener(MouseEvent.MOUSE_UP, scrollnub_onRelease);
				
				scrollnub.addEventListener(MouseEvent.MOUSE_OUT, scrollnub_onMouseOut);
				
				upArrow.addEventListener(MouseEvent.MOUSE_DOWN, upArrow_onPress);
				upArrow.addEventListener(MouseEvent.MOUSE_UP, upArrow_onRelease);
				
				dnArrow.addEventListener(MouseEvent.MOUSE_DOWN, dnArrow_onPress);
				dnArrow.addEventListener(MouseEvent.MOUSE_UP, dnArrow_onRelease);
				
			}
			myRect = new Rectangle(scrollnub.x, scrollwell.y, 0, scrollwell.height - scrollnub.height);
			
		}
		
		
		
		
		private function scrollnub_onPress(e:MouseEvent):void{
			
			scrollnub.startDrag(false,myRect);
			//startDrag(scrollnub, false, scrollnub.x, 0, scrollnub.x, copymask.height-scrollnub.height);
			scroll_ctr.visible = false;
			inner.addEventListener(Event.ENTER_FRAME, inner_onEnterFrame);	
		}
		private function scrollnub_onRelease(e:MouseEvent):void{
			scrollnub.stopDrag();
			inner.removeEventListener(Event.ENTER_FRAME, inner_onEnterFrame);
			scroll_ctr.y = scrollnub.y + (scrollnub.height/2) - (scroll_ctr.height/2);
			scroll_ctr.visible = true;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, scrollnub_onRelease);
			
		}
		private function scrollnub_onMouseOut(e:MouseEvent):void{
			if(e.buttonDown){   
				//scrollnub_onRelease(e); 
				
				stage.addEventListener(MouseEvent.MOUSE_UP, scrollnub_onRelease);
				
			}   
		}
		
		private function upArrow_onPress(e:MouseEvent):void{
			scroll_ctr.visible = false;
			inner.addEventListener(Event.ENTER_FRAME, inner_onEnterFrame);	
			
			scrollnub.y = Math.max(0, scrollnub.y - Math.round(scrollnub.height * 0.9));
		}
		private function upArrow_onRelease(e:MouseEvent):void{
			scroll_ctr.y = upArrow.y + (upArrow.height/2) - (scroll_ctr.height/2);
			scroll_ctr.visible = true;
			inner.removeEventListener(Event.ENTER_FRAME, inner_onEnterFrame);
		}
		
		private function dnArrow_onPress(e:MouseEvent):void{
			scroll_ctr.visible = false;
			inner.addEventListener(Event.ENTER_FRAME, inner_onEnterFrame);	

			scrollnub.y = Math.min(copymask.height-scrollnub.height, scrollnub.y + Math.round(scrollnub.height * 0.9));
		}
		private function dnArrow_onRelease(e:MouseEvent):void{
			scroll_ctr.y = dnArrow.y + (dnArrow.height/2) - (scroll_ctr.height/2);
			scroll_ctr.visible = true;
			inner.removeEventListener(Event.ENTER_FRAME, inner_onEnterFrame);
		}
		
		private function inner_onEnterFrame(e:Event):void{
			var scrollAmount:Number = (inner.height/copymask.height);
			scrollnub.height = copymask.height/scrollAmount;
			inner.y = -scrollnub.y*scrollAmount;
		}
		
	}
}