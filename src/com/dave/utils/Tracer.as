// Tracer.as
// AS3
// Dave Cole


package com.dave.utils {
	import flash.ui.Keyboard;
	import flash.display.*;
	import flash.text.TextField;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.events.*;
	import com.dave.net.GetURL;
	
	public class Tracer extends Sprite{
		private  var tFormat:TextFormat;
		private  var txt:TextField;
		private  var bkgBox:Sprite;
		private  var txt2:String;
		private  var showSelf:Boolean;
		private  var geturl:GetURL;
		
		public function Tracer(){
			bkgBox = new Sprite();
			bkgBox.graphics.lineStyle(0);
			bkgBox.graphics.beginFill(0xAAAAAA,0.6);
			bkgBox.graphics.drawRect(3,3,803, 503);
			addChild(bkgBox);
				
			txt = new TextField();
			txt.y = 5;
			txt.x = 5;
			txt.width = 800;
			txt.height = 500;
			addChild(txt);
			
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Arial";
			tFormat.color = 0xFFFFFF;
			tFormat.size = 6;
		
			txt.setTextFormat(tFormat);
			
			txt.text = txt2 = "";
			
			this.visible = false;
		}
		
		public  function init():void{
			
			
			if (stage != null){
				stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKey);
			}
		}
		
		public  function dtrace(str:String):void{
			txt.appendText(str + "\n");
			txt2 += str + "%0A";
			trace(str);
		}
		
		public  function checkKey(e:KeyboardEvent):void{
			trace("key pressed "+e.keyCode);
			if (e.keyCode == Keyboard.END && e.shiftKey){
				trace("SHOWING DATA");
				if (showSelf){
					showSelf = false;
					this.visible = false;
				} else {
					showSelf = true;
					this.visible = true;
				}
			} else if (e.keyCode == Keyboard.HOME && e.shiftKey){
				trace("SENDING DATA");
				geturl = new GetURL("mailto:dave@mekanism.com?subject=Debug%20Dump&body="+txt2);
			}
		}
		
		public function  kill():void{
			try { 
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKey);
			} catch (e:Error){
				
			} finally { 
			
			}
		}
		
		
	}
}
