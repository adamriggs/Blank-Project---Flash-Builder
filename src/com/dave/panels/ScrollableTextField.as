/*
// com.dave.panels.ScrollableTextField
// AS3 v1.0
// // Copyright 2007 Dave Cole - All Rights Reserved
//
//	The this Panel class instantiates a scrollable copy window.
//
//	Inputs: 
//		x,y:Number					x & y location to place Panel
//		txtWidth,txtHeight:Number	width and height of the scrollable text area.  Scrollbar is slightly larger to the right.
//		initText:String				Initial text to populate panel.
//		desiredFontReference:String	Reference to the desired symbol font linked from library.
//		desiredFontSize:Number		Desired font size.
//		fontColor:Number			Desired color for text.
//		doubleByte:Boolean			Passed in for localization.
//
// Methods:
//
//		setText(txt:String)		 	String of text to populate panel with
//
// Required Movie Clips:
//		ScrollableTextField folder
//
*/




//import com.dave.panels.Pane;
//import com.dave.panels.Panel;
package com.dave.panels {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	
	
	public class ScrollableTextField extends MovieClip{
		
		public var copymask,scrollnub,scrollwell,scroll_ctr:MovieClip;
		public var upArrow,dnArrow:SimpleButton;
		public var txtcopy:TextField;
		
		public var _styleSheet:StyleSheet;
		public var _styleObject:Object;
		private var _txtWidth:Number;
		private var _txtHeight:Number;
		private var _doubleByte:Boolean;
		private var _myFont:String;
		private var _myFontSize:Number;
		private var _myFontColor:Number;
		private var _scrollbarColor:Number;
		private var myTextFormat:TextFormat;
		private var myRect:Rectangle;
		private var targY:Number;
		private var ss:StyleSheet;
		
		public function ScrollableTextField(x:Number, y:Number, txtWidth:Number, txtHeight:Number, desiredFontReference:String, desiredFontSize:Number, fontColor:Number, doubleByte:Boolean, styleSheetTxt:String=""){
			trace("new ScrollableTextField("+x+","+y+","+txtWidth+","+txtHeight+",-,"+desiredFontReference+","+desiredFontSize+","+fontColor+","+doubleByte+");");

			this.x = x;
			this.y = y;
			_txtWidth = txtWidth;
			_txtHeight = txtHeight;
			_myFont = desiredFontReference;
			_myFontSize = desiredFontSize;
			_doubleByte = doubleByte;
			_myFontColor = fontColor;
			
			//_scrollbarColor = scrollbarColor;
		
			targY = 0;
			
			if (scroll_ctr == null){
				scroll_ctr = new MovieClip();
			}
			this.copymask.width = txtWidth;
			this.copymask.height = txtHeight;
			
			scrollnub.useHandCursor = scrollnub.buttonMode = true;
			
			
			txtcopy = new TextField();
			txtcopy.height = _txtHeight;
			txtcopy.width = _txtWidth;
			txtcopy.embedFonts = true;
			txtcopy.selectable = false;
			txtcopy.multiline = true;
			txtcopy.wordWrap = true;
			txtcopy.autoSize = TextFieldAutoSize.LEFT;
			//txtcopy.antiAliasType = AntiAliasType.ADVANCED;
			//txtcopy.html = true;
			addChild(txtcopy);
			
			this.txtcopy.mask = copymask;
			
			if (styleSheetTxt != ""){
				//ss = new StyleSheet();
				//ss.parseCSS(styleSheetTxt);
				//txtcopy.styleSheet = ss;
			}
			
		
			//parentPane.updateScroller();
		}
		
		public function setStyleSheet(styleSheetTxt:String):void{
			ss = new StyleSheet();
			ss.parseCSS(styleSheetTxt);
			txtcopy.styleSheet = ss;
		}
		
		public function resetStyleSheet():void{
			txtcopy.styleSheet = null;
		}
		
		public function setText(txt:String):void{
			//trace("ScrollableTextField.setText("+txt+")");
			
			myTextFormat = new TextFormat();
			myTextFormat.align = TextFormatAlign.LEFT;
			if (_doubleByte == false){
				myTextFormat.font = _myFont;
			} else {
				myTextFormat.font = "Verdana";
			}
			myTextFormat.size = _myFontSize;
	
			myTextFormat.color = _myFontColor;
			txtcopy.defaultTextFormat = myTextFormat;
			
			/*
			_styleSheet = new StyleSheet();
			_styleObject = new Object();
			_styleObject.fontFamily = _myFont;
			_styleObject.color = "#FFFFFF"; _myFontColor;
			_styleObject.fontSize = String(_myFontSize);
			_styleObject.textAlign = "left";
			_styleSheet.setStyle("p",_styleObject);
			
			txt = "<p>"+txt+"</p>";
			*/
			
			if (_doubleByte) {
				txtcopy.embedFonts = false;
			} else {
				txtcopy.embedFonts = true;
			}
			
			//txtcopy.styleSheet = _styleSheet;
			
			
			txtcopy.htmlText = txt;
			
			txtcopy.y = 0;
			scrollnub.y = 0;
			
			scrollwell.alpha = 0.5;
			
			
			updateScroller();
		}
		
		
		private function updateScroller():void{
			if (this.txtcopy.height <= this.copymask.height){
				this.scrollnub.visible = false;
				this.scrollwell.visible = false;
				this.scroll_ctr.visible = false;
				txtcopy.removeEventListener(Event.ENTER_FRAME, txtCopy_onEnterFrame);
				
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
				
				//var scrollAmount:Number = (this.txtcopy.metrics.height/this.copymask.height);
				var scrollAmount:Number = (this.txtcopy.height/this.copymask.height);
				this.scrollnub.height = this.copymask.height/scrollAmount;
						
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
			txtcopy.addEventListener(Event.ENTER_FRAME, txtCopy_onEnterFrame);	
		}
		private function scrollnub_onRelease(e:MouseEvent):void{
			scrollnub.stopDrag();
			txtcopy.removeEventListener(Event.ENTER_FRAME, txtCopy_onEnterFrame);
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
			txtcopy.addEventListener(Event.ENTER_FRAME, txtCopy_onEnterFrame);	
			
			scrollnub.y = Math.max(0, scrollnub.y - Math.round(scrollnub.height * 0.9));
		}
		private function upArrow_onRelease(e:MouseEvent):void{
			scroll_ctr.y = upArrow.y + (upArrow.height/2) - (scroll_ctr.height/2);
			scroll_ctr.visible = true;
			txtcopy.removeEventListener(Event.ENTER_FRAME, txtCopy_onEnterFrame);
		}
		
		private function dnArrow_onPress(e:MouseEvent):void{
			scroll_ctr.visible = false;
			txtcopy.addEventListener(Event.ENTER_FRAME, txtCopy_onEnterFrame);	

			scrollnub.y = Math.min(copymask.height-scrollnub.height, scrollnub.y + Math.round(scrollnub.height * 0.9));
		}
		private function dnArrow_onRelease(e:MouseEvent):void{
			scroll_ctr.y = dnArrow.y + (dnArrow.height/2) - (scroll_ctr.height/2);
			scroll_ctr.visible = true;
			txtcopy.removeEventListener(Event.ENTER_FRAME, txtCopy_onEnterFrame);
		}
		
		private function txtCopy_onEnterFrame(e:Event):void{
			trace("txtCopy_onEnterFrame");
			var scrollAmount:Number = (txtcopy.height/copymask.height);
			scrollnub.height = copymask.height/scrollAmount;
			txtcopy.y = -scrollnub.y*scrollAmount;
		}
		
		public function resize(w:Number,h:Number):void{
			_txtHeight = h;
			_txtWidth = w;
			txtcopy.height = _txtHeight;
			txtcopy.width = _txtWidth;
			this.copymask.width = _txtWidth;
			this.copymask.height = _txtHeight;
			updateScroller();
		}
		
	}
}