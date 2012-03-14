package org.casalib.display.components.containers 
{
	import org.casalib.collection.iterators.DisplayObjectContainerIterator;
	import org.casalib.display.CasaSprite;
	import org.casalib.layout.Layout;
	import org.casalib.layout.positioning.WrapType;

	import flash.display.DisplayObject;

	/**
	 * @author Jon Adams
	 */
	public class Box extends CasaSprite {

		public static const VERTICLE:String = "verticle";		public static const HORIZONTAL:String = "horizontal";
		
		private var _direction:String;		private var _padding:Number = 0;
		private var snap:Boolean;

		public function Box(direction:String = HORIZONTAL, snap:Boolean = true) {
			
			this.snap = snap;
			this.direction = direction;
		}

		public function position():void {
			var iterator:DisplayObjectContainerIterator = new DisplayObjectContainerIterator(this);
			while(iterator.hasNext()) {
				var child:DisplayObject = iterator.next() as DisplayObject;
				if(child is Box){
					var box:Box = child as Box;
					box.position();
				}
			}
			
			var layout:Layout = new Layout(this);
			if(direction == VERTICLE){
				layout.wrapType = WrapType.TOP_TO_BOTTOM_LEFT_TO_RIGHT;
			} 
			layout.addChildren(this, 0, padding, padding);
			layout.position();
		}
		
		public function get direction():String {
			return _direction;
		}
		
		public function set direction(direction:String):void {
			_direction = direction;
		}
		
		public function get padding():Number {
			return _padding;
		}
		
		public function set padding(padding:Number):void {			_padding = padding;
		}
	}
}
