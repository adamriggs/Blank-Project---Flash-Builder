// ExternalAsset (extends Sprite)
// AS3 v1.0
// Copyright 2007 Dave Cole - All Rights Reserved
// 
//
//  License: Only Dave Cole and active Mekanism employees or contractors may use this code.
//
// Usage:
//
// asset = new ExternalAsset( args );
// 
// asset.onLoaded = function(){ ... process the asset, once loaded, the asset is a child of the ExternalAsset ... }
//
// addChild(asset);
//

package com.dave.utils{
	import flash.display.AVM1Movie;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.*;
	import flash.utils.*;
	
	public class ExternalAsset extends Sprite{
		public var loader:Loader;
		public var context:LoaderContext;
		public var file:String;
		public var onLoaded:Function;
		public var inner:Bitmap;
		public var innerMask:Sprite;
		public var innerBitmapData:BitmapData;
		public var policyOverride:Boolean;
		private var __smoothing:Boolean;
		private var success:Boolean;
		private var isAS2SWF:Boolean;
		private var isAS3SWF:Boolean;
		public var innerSWF:AVM1Movie;
		public var innerAS3SWF:MovieClip;
		public var extra:Object;
		public var noLetterbox:Boolean = false;
		public var origWidth:Number;
		public var origHeight:Number;
		
		public function ExternalAsset(_policyOverride:Boolean=false, _smoothing:Boolean=false, _isAS2SWF:Boolean=false, _isAS3SWF:Boolean=false){
			loader = new Loader();
			policyOverride = _policyOverride;
			if(Capabilities.playerType == "External"){
				policyOverride = false;
			} else {
				policyOverride = true;
			}
			
			if (policyOverride){
				context = new LoaderContext(true);
				context.checkPolicyFile = true;
			}
			isAS2SWF = _isAS2SWF;
			isAS3SWF = _isAS3SWF;
			__smoothing = _smoothing;
			success = true;
			extra = {};
			
			loader.contentLoaderInfo.addEventListener( Event.INIT, handleInit );
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			onLoaded = function(target:Object, success:Boolean):void{ };
			
			/*if (filename.length > 0){
				load(filename[0]);
			} */
			
			innerMask = drawRect(100,100);
		}
		
		public function load(filename:String):void{
			file = filename;
			loader.load( new URLRequest(filename),context);
		}
		
		public function unload():void{
			loader.unload();
		}
		
		public function get smoothing():Boolean{
			if (inner){
				return(inner.smoothing);
			} else {
				return(false);
			}
		}
		
		public function set smoothing(b:Boolean):void{
			if (inner){
				inner.smoothing = b;
			}
			__smoothing = b;
		}
		
		private function handleInit(event:Event):void{
			try {
				
				if (!policyOverride){
					//trace('b');
					if (!isAS2SWF && !isAS3SWF){
						
						inner = event.target.content;
						origWidth = loader.width;
						origHeight = loader.height;
						if (noLetterbox){
							inner.bitmapData = removeLetterbox(event.target.content.bitmapData, 0xff111111);
							origWidth = inner.bitmapData.width;
							origHeight = inner.bitmapData.height;
						}
						//trace("inner == "+inner);
						if (__smoothing){
							inner.smoothing = true;
						}
						
						addChild(inner);
						addChild(innerMask);
						innerMask.width = origWidth;
						innerMask.height = origHeight;
						inner.mask = innerMask;
					} else if (isAS2SWF){
						innerSWF = event.target.content;
						
						addChild(innerSWF);
					} else if (isAS3SWF){
						innerAS3SWF = event.target.content;
						addChild(innerAS3SWF);
					}
					
					loader = null;
					
				} else {
					//trace('c '+loader.width+" "+loader.height);
					innerBitmapData = new BitmapData(loader.width, loader.height,false);
					origWidth = loader.width;
					origHeight = loader.height;
					innerBitmapData.draw(loader);
					if (noLetterbox){
						innerBitmapData = removeLetterbox(innerBitmapData,0xff111111);
					}
					if (inner){
						try {
							removeChild(inner);
						} catch (e:Error){}
					}
					inner = new Bitmap();
					inner.bitmapData = innerBitmapData;
					//trace("new size: "+innerBitmapData.width+" "+innerBitmapData.height);
					origWidth = innerBitmapData.width;
					origHeight = innerBitmapData.height;
					inner.smoothing = __smoothing;
					addChild(inner);
					addChild(innerMask);
					innerMask.width = origWidth;
					innerMask.height = origHeight;
					inner.mask = innerMask;
				}
				//trace('d '+this.onLoaded);
				this.onLoaded(this, true);
				//trace('e');
			
			} catch ( e:TypeError ){
				trace("com.dave.utils.ExternalAsset: ERROR loading File '"+file+"': "+e.message);
				this.onLoaded(this, false);
			}
		}
		
		public function removeLetterbox(bmp:BitmapData, thresholdColor:uint = 0xff111111):BitmapData {
			// Optionally threshold the image so smaller artifacts don't affect
			var threshBmp:BitmapData = bmp.clone();
			threshBmp.threshold(threshBmp, threshBmp.rect, new Point(), "<=", thresholdColor, 0xff000000, 0xffffffff, true);
			
			var rect:Rectangle 		= threshBmp.getColorBoundsRect(0xffffffff, 0xff000000, false);
			
			// If rect is tiny, then threshold cut too much
			if(rect.width < 1 || rect.height < 1) return bmp;
			
			var newBmp:BitmapData	= new BitmapData(rect.width, rect.height, false, 0x0);
			var mat:Matrix 			= new Matrix(1, 0, 0, 1, -rect.x, -rect.y);
			
			newBmp.draw(bmp, mat, null, null, null, false);
			
			return newBmp;
			
		}
		
		private function drawRect(w:Number, h:Number, c:Number=0xFF0000):Sprite{
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(-1,c);
			s.graphics.beginFill(c);
			s.graphics.drawRect(0,0,w,h);
			s.graphics.endFill();
			return(s);
		}
		
		
		public function ioErrorHandler(e:Event):void{
			trace("loader error! -  error loading file "+file);
			this.onLoaded(this, false)
		}
		
		public function destroy():void{
			this.unload();
			
			if(this.numChildren!=0){
				var k:int = this.numChildren;
				while( k -- )
				{
					this.removeChildAt( k );
				}
			}
			
			inner = null;
			innerBitmapData = null;
			loader = null;
		}
	}
}