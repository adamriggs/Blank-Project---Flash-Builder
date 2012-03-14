// com.app.PlaneLoader
// Adam Riggs
//
package com.app {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.*;
	import caurina.transitions.*;
	
	import com.dave.utils.DaveTimer;
	import com.dave.events.*;
	
	import away3d.primitives.Plane;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.BitmapFileMaterial;
	import away3d.materials.WhiteShadingBitmapMaterial;
	import away3d.materials.MovieMaterial;
	//import away3d.materials.ColorShadingMaterial;
	import away3d.containers.ObjectContainer3D;
	import away3d.events.MaterialEvent;
	import away3d.core.utils.Cast;
	
	
	public class PlaneLoader extends ObjectContainer3D {
		
		public var imgName:String;
		public var matType:String;
		public var initFinished:Boolean;
		
		public var ident:int;
		
		public var pw:Number;
		public var ph:Number;
		
		public var plane:Plane;
		public var bmm:BitmapMaterial;
		public var bmfm:BitmapFileMaterial;
		public var wsbm:WhiteShadingBitmapMaterial;
		public var mm:MovieMaterial;
		public var thumbLoader:ThumbLoader;
		
		public function PlaneLoader(n:String, w:Number, h:Number, m:String="bitmap"){
			imgName=n;
			matType=m;
			pw=w;
			ph=h;
			init();
		}
		
//*****Initalization Functions
		
		public function init(){
			//this.visible = false;
			//trace("PlaneLoader() init");
			EventCenter.subscribe("onNav",onNav);
			EventCenter.subscribe("onThumbLoader", onThumbLoader);
		
			//DaveTimer.wait(200,lateInit);
			initFinished=false;
			initMaterial();
		}
		
		public function initMaterial():void{
			//trace("imgName=="+imgName);
			
			switch(matType){
				
				case "bitmap":
					
					bmfm=new BitmapFileMaterial(imgName);
					bmfm.smooth=true;
					
					initPlane();
				
				break;
				
				case "shading":
					trace("initMaterial shading");
					/*var index:int=imgName.lastIndexOf("/")+1;
					thumbLoader=new ThumbLoader(imgName.slice(index));
					//trace(imgName+"imgName.slice(imgName.lastIndexOf("/")+1)=="+imgName.slice(imgName.lastIndexOf("/")+1));
					trace("*****"+imgName+" index=="+imgName.slice(index));*/
				break;
				
				case "movie":
				
				break;
				
				case "thumbLoader":
					var index:int=imgName.lastIndexOf("/")+1;
					thumbLoader=new ThumbLoader();
					//trace(imgName+"imgName.slice(imgName.lastIndexOf("/")+1)=="+imgName.slice(imgName.lastIndexOf("/")+1));
					thumbLoader.loadThumb(imgName.slice(index),pw,ph);
					trace("*****"+imgName+" index=="+imgName.slice(index));
				
				break;
				
			}
		}
		
		public function initPlane():void{
			
			switch(matType){
				case "bitmap":
					bmfm.smooth=true;
					plane=new Plane({material:bmfm});
					//plane.bothsides=true;
					addChild(plane);
				break;
				
				case "shading":
					wsbm=new WhiteShadingBitmapMaterial(Cast.bitmap(thumbLoader.thumbBM));
					wsbm.smooth=true;
					wsbm.shininess=1;
					plane=new Plane({material:wsbm});
					//trace("PlaneLoader "+imgName+" material created");
				break;
				
				case "movie":
				
				break;
				
				case "thumbLoader":
					bmm=new BitmapMaterial(Cast.bitmap(thumbLoader.thumbBM));
					bmm.smooth=true;
					plane=new Plane({material:bmm});
					addChild(plane);
				break;
			
			}
			//plane=new Plane({material:"white#black"});
			plane.width=pw;
			plane.height=ph;
			//plane.y=plane.height/2;
			//plane.x=plane.width/2;
			plane.z=0;
			plane.useHandCursor=true;
			plane.rotationX=90;
			//addChild(plane);
			initFinished=true;
			trace("PlaneLoader "+imgName+" initFinished=="+initFinished);
			var transPlane:Plane=plane;
			EventCenter.broadcast("onPlaneLoader", {type:matType, obj:transPlane});
		}
		
//*****Core Functionality
		
//*****Event Handlers
		
		public function onThumbLoader(e:ApplicationEvent):void{
			//trace("PlaneLoader - onThumbLoader e.args.status=="+e.args.status);
			switch(e.args.status){
				
				case "finished":
					if(!initFinished){
						trace("PlaneLoader shading ThumbLoader loaded");
						trace("PlaneLoader imgName=="+imgName);
						if(thumbLoader.loadingStatus=="finished"){
							initPlane();
						}
					}
				break;
				
			}
			
		}
		
		public function onNav(e:ApplicationEvent){
			//trace("PlaneLoader.onNav - "+e.args.destination);
			
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