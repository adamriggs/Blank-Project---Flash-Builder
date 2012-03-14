package org.casalib.layout.positioning {
	import org.casalib.layout.Layout;

	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	/**
	 * @author Jon Adams
	 */
	public class SubLayoutMember implements ILayoutMember {

		public var layout:Layout;
		
		private var top:Number;
		private var left:Number;
		private var right:Number;
		private var bottom:Number;

		public function SubLayoutMember(layout:Layout, top:Number, bottom:Number, left:Number, right:Number) {
			this.top = top;
			this.right = right;
			this.bottom = bottom;
			this.left = left;
			this.layout = layout;
		}

		public function position(targetCoordinateSpace:DisplayObjectContainer, bounds:Rectangle, snap:Boolean):void {
			var alignBounds:Rectangle = bounds.clone();
			
			alignBounds.top += top;
			alignBounds.left += left;
			
			var temp:Rectangle = layout.bounds;
			layout.bounds = alignBounds;
			layout.position();
			layout.bounds = temp;
		}
		
		public function getBounds(targetCoordinateSpace:DisplayObjectContainer):Rectangle {
			var rectangle:Rectangle = layout.position().clone();
			rectangle.top -= top;
			rectangle.right += right;
			rectangle.bottom += bottom;
			rectangle.left -= left;
			
			return rectangle;
		}
	}
}
