// com.dave.papervision.LevelEditor
//	Dave Cole
//
//	An object that will let you index through objects in a live papervision scene and nudge their positions and rotations.
//	A How-To menu is traced when you instantiate this object.
//
package com.dave.papervision {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	
	
	// Import Papervision3D
	
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.scenes.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.utils.*;
	import org.papervision3d.objects.Sphere;
	import org.papervision3d.utils.virtualmouse.VirtualMouse;
	import org.papervision3d.utils.virtualmouse.IVirtualMouseEvent;
	import org.papervision3d.utils.InteractiveSceneManager;
	import org.papervision3d.core.*;
	
	public class LevelEditor extends Sprite{
		
		private var scene:Scene3D;
		public var objectIndex:int;
		private var incrementAmount:int;
		private var blinkTimer:Timer;
		private var active:Boolean;
		private var blink:Boolean;
		private var i:uint;
		private var lastObjectAnimated:Boolean;
		private var currentObject:DisplayObject3D;
		private var m:MovieMaterial;
		private var objectCount:int;
		private var objects:Array;
		
		public function LevelEditor(sceneRef:Scene3D){
			scene = sceneRef;
			objectIndex = 0;
			init();
		}
		
		public function init(){
			//this.visible = false;
			trace("LevelEditor init");
			trace("------------------------------------");
			trace("`                  : activate editor");
			trace(": - last object, ' - next object");
			trace("left/right arrow   : -/+ x");
			trace("up/down arrow      : -/+ y");
			trace("[ or ]             : -/+ z");
			trace("1 or 2             : -/+ rotationX");
			trace("3 or 4             : -/+ rotationY");
			trace("5 or 6             : -/+ rotationZ");
			trace("SHIFT              : nudge * 10");
			trace("------------------------------------");
			incrementAmount = 10;
			blinkTimer = new Timer(300,0);
			blinkTimer.addEventListener(TimerEvent.TIMER, onBlink);
			blink = false;
			blinkTimer.stop();
		}
		

			
		public function lateInit(e:Event=null){
			currentObject = scene.objects[objectIndex];
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			objects = scene.objects;
			objectCount = objects.length;
		}
		
		private function refreshSelected(){
			try {
				trace("Selected "+objectIndex+"/"+(objectCount - 1)+" : "+currentObject.name+" - "+currentObject+" rX: "+currentObject.rotationX+" rY: "+currentObject.rotationY+" rZ: "+currentObject.rotationZ);
			} catch (e:Error){
				
			}
		}
		
		private function onBlink(e:TimerEvent){
			try {
				if (!blink){
					currentObject.container.alpha = 0.5;
					blink = true;
				} else {
					currentObject.container.alpha = 1;
					blink = false;
				}
			} catch (e:Error){
				
			}
		}
		
		private function key_down(e:KeyboardEvent){
			
			switch (e.keyCode){
				case 38: // up
					currentObject.y += (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
				case 40: // down
					currentObject.y -= (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
				case 37: // left
					currentObject.x -= (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
				case 39: // right 
					currentObject.x += (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
				case 219: // [
					currentObject.z -= (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
				case 221: // ]
					currentObject.z += (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
				case 222: // '
					trace("next");
					try {
						m = currentObject.material as MovieMaterial;
						m.animated = lastObjectAnimated;
						currentObject.container.alpha = 1;
					} catch (e:Error){
						trace('doh');
					}
					objectIndex++;
					
					if (objectIndex >= objectCount){
						objectIndex = 0;
					}
					trace("objectIndex == "+objectIndex);
					if (objects[objectIndex] == null){
						objectIndex++;
						if (objectIndex >= objectCount){
							objectIndex = 0;
						}
					}
					try {
						currentObject = objects[objectIndex];
						m = currentObject.material as MovieMaterial;
						lastObjectAnimated = m.animated;
						m.animated = true;
					} catch (e:Error){
						trace("** WARNING: out of range - objectIndex=="+objectIndex);
					}
					break;
				case 192: // `
					if (active){
						trace("LevelEditor DEACTIVATED");
						active = false;
						currentObject.container.alpha = 1;
						m = currentObject.material as MovieMaterial;
						m.animated = lastObjectAnimated;
						objectCount = scene.objects.length;
						objects = scene.objects;
						blinkTimer.stop();
						blink = false;
					} else {
						trace("LevelEditor ACTIVATED");
						active = true;
						objectCount = scene.objects.length;
						m = currentObject.material as MovieMaterial;
						lastObjectAnimated = m.animated;
						objects = scene.objects;
						m.animated = true;
						blinkTimer.start();
						trace("objindex == "+objectIndex);
					}
					break;
				case 186: // ;
					trace("prev");
					try {
						m = currentObject.material as MovieMaterial;
						m.animated = lastObjectAnimated;
						currentObject.container.alpha = 1;
					} catch (e:Error){
						trace('doh');
					}
					
					objectIndex = objectIndex - 1;
					
					if (objectIndex < 0){
						objectIndex = (objectCount) - 1;
					}
					
					trace("objectIndex == "+objectIndex);
					try {
						currentObject = objects[objectIndex];
						m = currentObject.material as MovieMaterial;
						lastObjectAnimated = m.animated;
						m.animated = true;
					} catch (e:Error){
						trace("** WARNING: out of range - objectIndex=="+objectIndex);
					}
					break;
				//case 16: // shift
					
					//break;
				case 48: // 0
					
					break;
				case 49: // 1
					currentObject.rotationX -= (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
				case 50: // 2
					currentObject.rotationX += (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
				case 51: // 3
					currentObject.rotationY -= (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
				case 52: // 4
					currentObject.rotationY += (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
				case 53: // 5
					currentObject.rotationZ -= (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
				case 54: // 6
					currentObject.rotationX += (e.shiftKey ? incrementAmount * 10 : incrementAmount);
					break;
			}
			refreshSelected();
		}
		
	}
}