/*
// com.dave.panels.ThumbnailScroller
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
//
// Defined a horizontal or vertical system of thumbnails which are scrolled one at a time left or right, up or down, extend this class
// to make it specific to your purposes.  Automatically wraps thumbnails.
//
//	Skinnable:
//		assumes three elements: arrow_left, arrow_right, and masker
*/

package com.dave.panels {
	import flash.display.*;
	import flash.events.*;
	import caurina.transitions.*;
	import com.dave.panels.Thumbnail;
	
	public class ThumbnailScroller extends Sprite {
		
		public var THUMBNAIL_COUNT:int;
		
		public var arrow_left,arrow_right,arrow_up,arrow_down,masker:Sprite;
		
		public var thumbnailClip:Sprite;
		
		private var baseLeft:int;
		private var tileDistance:int;
		public var isSliding:Boolean;
		
		private var _direction:int;
		private var _lastDirection:int;
		
		private var amount:int;
		
		public var thumbItems:Array;
		public var thumbItemsIndex:int;
		public var dataArray:Array;
		
		public var thumbnailClass:Class;
		
		public var thumbnailOffset:int;
		
		public var isHorizontal:Boolean;
		public var cacheMaskAsBitmap:Boolean;
		
		public var thumbnail:Thumbnail;
		
		private var i:int;
		
		public function ThumbnailScroller(_dataArray:Array, thumbnailCount:int, _baseLeft:int, _tileDistance:int, _thumbnailClass:Class, _isHorizontal:Boolean=true, _thumbnailOffset:int=0, _cacheMaskAsBitmap:Boolean=false, smallLoop=false){
			trace("new ThumbnailScroller("+_dataArray+", "+thumbnailCount+", "+_baseLeft+", "+_tileDistance+", "+_thumbnailClass+", "+_isHorizontal);
			THUMBNAIL_COUNT = thumbnailCount;
			baseLeft = _baseLeft;
			tileDistance = _tileDistance;
			isHorizontal = _isHorizontal
			thumbnailClass = _thumbnailClass;
			thumbnailOffset = _thumbnailOffset;
			cacheMaskAsBitmap = _cacheMaskAsBitmap;
			dataArray = new Array();
			
			for(i=0; i < _dataArray.length; i++){
				dataArray[i] = _dataArray[i];
			}
			if (smallLoop){
				for (i=0; i < _dataArray.length; i++){
					dataArray.push(_dataArray[i]);
				}
			}
			trace("dataArray.length == "+dataArray.length);
			init();
		}
		
		public function init():void{
			trace("ThumbnailScroller.init()");
			
			// add thumbnail content clip & mask it
			thumbnailClip = new Sprite();
			addChild(thumbnailClip);
			thumbnailClip.x = masker.x;
			thumbnailClip.y = masker.y;
			masker.cacheAsBitmap = cacheMaskAsBitmap;
			thumbnailClip.cacheAsBitmap = cacheMaskAsBitmap;
			thumbnailClip.mask = masker;
			//masker.visible = false;
			
			isSliding = false;
			
			thumbItems = new Array();
			thumbItemsIndex = 0;
			
			_lastDirection = 0;
			_direction = 0;
			
			for(i=0; i < Math.min(THUMBNAIL_COUNT, dataArray.length); i++){
				trace("new "+thumbnailClass);
				thumbItems.push(new thumbnailClass());
				if (isHorizontal){
					thumbItems[thumbItems.length - 1].x = baseLeft + (tileDistance * i);
					thumbItems[thumbItems.length - 1].y = thumbnailOffset;
				} else {
					thumbItems[thumbItems.length - 1].y = baseLeft + (tileDistance * i);
					thumbItems[thumbItems.length - 1].x = thumbnailOffset;
				}
				thumbItems[thumbItems.length - 1].myPosition = i;
				trace("init populating - "+i);
				thumbItems[thumbItems.length - 1].populate(dataArray[i]);  // i, type, charInfo
				thumbnailClip.addChild(thumbItems[thumbItems.length - 1]);
			}
			
			if (dataArray.length > THUMBNAIL_COUNT){
				thumbItems.push(new thumbnailClass());
				if (isHorizontal){
					thumbItems[thumbItems.length - 1].x = baseLeft + (tileDistance * THUMBNAIL_COUNT);
					thumbItems[thumbItems.length - 1].y = thumbnailOffset;
				} else {
					thumbItems[thumbItems.length - 1].y = baseLeft + (tileDistance * THUMBNAIL_COUNT);
					thumbItems[thumbItems.length - 1].x = thumbnailOffset;
				}
				thumbItems[thumbItems.length - 1].myPosition = THUMBNAIL_COUNT;
				trace("init populating - "+THUMBNAIL_COUNT);
				thumbItems[thumbItems.length - 1].populate(dataArray[THUMBNAIL_COUNT]);  // THUMBNAIL_COUNT, type, charInfo
				thumbnailClip.addChild(thumbItems[thumbItems.length - 1]);
				//trace("done init");
			}
			
			trace("arrow inits");
			// add arrow inits
			if (isHorizontal){
				arrow_left.mouseEnabled = arrow_right.mouseEnabled = true;
				arrow_left.buttonMode = arrow_right.buttonMode = true;
				arrow_left.addEventListener(MouseEvent.CLICK, arrow_left_click);
				arrow_right.addEventListener(MouseEvent.CLICK, arrow_right_click);
			} else {
				arrow_up.mouseEnabled = arrow_down.mouseEnabled = true;
				arrow_left.buttonMode = arrow_right.buttonMode = true;
				arrow_up.addEventListener(MouseEvent.CLICK, arrow_left_click);
				arrow_down.addEventListener(MouseEvent.CLICK, arrow_right_click);
			}
			trace("done arrow inits");
			
			onInit();
		}
		
		public function arrow_left_click(e:Event):void{
			if (!isSliding){
				slide(-1);
			}
		}
		
		public function arrow_right_click(e:Event):void{
			if (!isSliding){
				slide(1);
			}
		}
		
		public function onSlideLeft():void{
			
		}
		
		public function onSlideRight():void{
			
		}
		
		public function onInit():void{
			
		}
		
		public function slide(direction:Number):void{
			if (!isSliding){
				_lastDirection = _direction;
				_direction = direction;
				
				isSliding = true;
				if (_direction == 1){
					// slide left (right arrow)
					//trace("left/1 THUMBNAIL_COUNT == "+THUMBNAIL_COUNT+"  dataArray.length == "+dataArray.length);
					//trace("thumbItemsIndex A: "+thumbItemsIndex);
					if (_lastDirection == 0){
						thumbItemsIndex = THUMBNAIL_COUNT;
					} else if (_lastDirection == _direction){
						thumbItemsIndex += 1;
					} else {
						thumbItemsIndex += THUMBNAIL_COUNT;  // -= (THUMBNAIL_COUNT - 1);
					}
					//trace("thumbItemsIndex B: "+thumbItemsIndex);
					
					var amount:int;
					if (thumbItemsIndex >= dataArray.length){
						amount = thumbItemsIndex - dataArray.length;
						thumbItemsIndex = 0 + amount;
					} else if (thumbItemsIndex < 0){
						amount = 0 - thumbItemsIndex;
						thumbItemsIndex = dataArray.length - amount;
					}
					trace("thumbItemsIndex C: "+thumbItemsIndex);
					
					if (isHorizontal){
						thumbItems[THUMBNAIL_COUNT].x = baseLeft + (THUMBNAIL_COUNT * tileDistance);
					} else {
						thumbItems[THUMBNAIL_COUNT].y = baseLeft + (THUMBNAIL_COUNT * tileDistance);
					}
					trace("populating - "+thumbItemsIndex);
					thumbItems[THUMBNAIL_COUNT].populate(dataArray[thumbItemsIndex]);
					
					for(i=0; i < THUMBNAIL_COUNT; i++){
						thumbItems[i].myPosition = i - 1;
						//thumbItems[i].btn.enabled = true
					}
					
					thumbnail = thumbItems[0];
					thumbItems.splice(0,1);
					thumbItems[THUMBNAIL_COUNT] = thumbnail;
					
					for (i=0; i < THUMBNAIL_COUNT; i++){
						/*if (thumbItems[i].visible == false){
							thumbItems[i].alpha = 0;
							thumbItems[i].visible = true;
						}
						Tweener.addTween(thumbItems[i], { alpha: 1, time: 0.4, "easeOutQuad" });
						*/
						if (isHorizontal){
							Tweener.addTween(thumbItems[i], { x: thumbItems[i].x - tileDistance, time: 0.4, transition:"easeOutQuad" });
						} else {
							Tweener.addTween(thumbItems[i], { y: thumbItems[i].y - tileDistance, time: 0.4, transition:"easeOutQuad" });
						}
					}
					if (isHorizontal){
						Tweener.addTween(thumbItems[THUMBNAIL_COUNT], { x: thumbItems[THUMBNAIL_COUNT].x - tileDistance, time: 0.4, transition:"easeOutQuad", onComplete: function(){ isSliding = false; } });
					} else {
						Tweener.addTween(thumbItems[THUMBNAIL_COUNT], { y: thumbItems[THUMBNAIL_COUNT].y - tileDistance, time: 0.4, transition:"easeOutQuad", onComplete: function(){ isSliding = false; } });
					}
					//Tweener.addTween(thumbItems[THUMBNAIL_COUNT], { alpha: 0, time: 0.4, transition:"easeOutQuad", onComplete: function(){ thumbItems[THUMBNAIL_COUNT].visible = false; });
					onSlideLeft();
				} else {
					// slide right (left arrow)
					//trace("right/-1 THUMBNAIL_COUNT == "+THUMBNAIL_COUNT+"  dataArray.length == "+dataArray.length);
					//trace("thumbItemsIndex A: "+thumbItemsIndex);
					if (_lastDirection == 0){
						thumbItemsIndex = dataArray.length - 1;
					} else if (_lastDirection == _direction){
						thumbItemsIndex -= 1;
					} else {
						thumbItemsIndex -= THUMBNAIL_COUNT;  // += (THUMBNAIL_COUNT - 1);
					}
					
					//trace("thumbItemsIndex B: "+thumbItemsIndex);
					if (thumbItemsIndex >= dataArray.length){
						amount = thumbItemsIndex - dataArray.length;
						thumbItemsIndex = 0 + amount;
					} else if (thumbItemsIndex < 0){
						amount = 0 - thumbItemsIndex;
						thumbItemsIndex = dataArray.length - amount;
					}
					
					trace("thumbItemsIndex C: "+thumbItemsIndex);
					
					if (isHorizontal){
						thumbItems[THUMBNAIL_COUNT].x = baseLeft - tileDistance;
					} else {
						thumbItems[THUMBNAIL_COUNT].y = baseLeft - tileDistance;
					}
					trace("populating - "+thumbItemsIndex);
					thumbItems[THUMBNAIL_COUNT].populate(dataArray[thumbItemsIndex]);
					
					for(i=0; i < THUMBNAIL_COUNT; i++){
						thumbItems[i].myPosition = i + 1;
						if (thumbItems[i].myPosition == THUMBNAIL_COUNT){
							thumbItems[i].myPosition = -1;
						}
					}
					
					thumbnail = thumbItems[THUMBNAIL_COUNT];
					thumbItems.splice(THUMBNAIL_COUNT,1);
					thumbItems.unshift(thumbnail);
					
					
					for (i=0; i < THUMBNAIL_COUNT; i++){
						/*
						if (thumbItems[i].visible = false){
							thumbItems[i].alpha = 0;
							thumbItems[i].visible = true;
						}
						*/
						if (isHorizontal){
							Tweener.addTween(thumbItems[i], { x: thumbItems[i].x + tileDistance, time: 0.4, transition: "easeOutQuad" });
						} else {
							Tweener.addTween(thumbItems[i], { y: thumbItems[i].y + tileDistance, time: 0.4, transition: "easeOutQuad" });
						}
						//Tweener.addTween(thumbItems[i], { alpha: 1, time: 0.4, transition: "easeOutQuad" });
					}
					if (isHorizontal){
						Tweener.addTween(thumbItems[THUMBNAIL_COUNT], { x: thumbItems[THUMBNAIL_COUNT].x + tileDistance, time: 0.4, transition: "easeOutQuad", onComplete: function(){ isSliding = false; } });
					} else {
						Tweener.addTween(thumbItems[THUMBNAIL_COUNT], { y: thumbItems[THUMBNAIL_COUNT].y + tileDistance, time: 0.4, transition: "easeOutQuad", onComplete: function(){ isSliding = false; } });
					}
					//Tweener.addTween(thumbItems[THUMBNAIL_COUNT], { alpha: 0, time: 0.4, transition: "easeOutQuad" });
					onSlideRight();
				}
			}
		}
		
	}
}

