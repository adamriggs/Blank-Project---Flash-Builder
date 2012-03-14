package org.casalib.layout.positioning {
	import flash.display.DisplayObject;
	import org.casalib.util.AlignUtil;

	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	/**
	 * @author Jon Adams
	 */
	public class LayoutMember implements ILayoutMember {

		public var displayObject:DisplayObject;
		
		private var top:Number;
		private var left:Number;
		private var right:Number;
		private var bottom:Number;

		public function LayoutMember(displayObject:DisplayObject, top:Number, bottom:Number, left:Number, right:Number) {
			this.top = top;
			this.right = right;			this.bottom = bottom;			this.left = left;
			this.displayObject = displayObject;
		}
		
		public function position(targetCoordinateSpace:DisplayObjectContainer, bounds:Rectangle, snap:Boolean):void {
			var alignBounds:Rectangle = bounds.clone();
			
			alignBounds.top += top;
			alignBounds.left += left;
			
			AlignUtil.alignTopLeft(displayObject, alignBounds, snap, false, targetCoordinateSpace);
		}
		
		public function getBounds(targetCoordinateSpace:DisplayObjectContainer):Rectangle {
			var rectangle:Rectangle = displayObject.getBounds(targetCoordinateSpace);
			rectangle.top -= top;
			rectangle.right += right;
			rectangle.bottom += bottom;
			rectangle.left -= left;
			
			return rectangle;
		}
	}
}
