package com.dave.ui
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class ALabel extends ASprite
	{
		public var tf:TextField;
		
		public function ALabel()
		{
			super();
			if (hasOwnProperty("_tf")) {
				tf = TextField(this['_tf']);
				tf.selectable=false;
				tf.mouseEnabled=false;
			} else {
				throw new Error(this.toString()+": missing _tf instance on stage.");
			}
			
		}
		
		public function set text(value:String):void
		{
			tf.text = value;
			tf.autoSize =  TextFieldAutoSize.LEFT;
		}
		
		public function get text():String
		{
			return tf.text;
		}
		
		public function set htmlText(value:String):void
		{
			tf.htmlText = value;
		}
		
		public function get htmlText():String
		{
			return tf.htmlText;
		}
	}
}