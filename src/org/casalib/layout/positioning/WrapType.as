package org.casalib.layout.positioning {
	import org.casalib.util.AlignUtil;

	import flash.geom.Rectangle;

	/**
	 * @author Jon Adams
	 */
	public final class WrapType {

		public static const LEFT_TO_RIGHT_TOP_TO_BOTTOM:WrapType = new WrapType();
		public static const RIGHT_TO_LEFT_TOP_TO_BOTTOM:WrapType = new WrapType();
		public static const LEFT_TO_RIGHT_BOTTOM_TO_TOP:WrapType = new WrapType();
		public static const RIGHT_TO_LEFT_BOTTOM_TO_TOP:WrapType = new WrapType();
		public static const TOP_TO_BOTTOM_RIGHT_TO_LEFT:WrapType = new WrapType();
		public static const TOP_TO_BOTTOM_LEFT_TO_RIGHT:WrapType = new WrapType();
		public static const BOTTOM_TO_TOP_LEFT_TO_RIGHT:WrapType = new WrapType();
		public static const BOTTOM_TO_TOP_RIGHT_TO_LEFT:WrapType = new WrapType();
		
		// Not really sure why but Rectangle cant have negative infinity top or 
		//left and this number seams to be magic. I tried Number.MAX_VALUE and
		//Number.MIN_VALUE but that didn't work.
		private static const MAXSIZE:Number = 0xFFFFFF;

		public static function getPrimaryAlignment(flowType:WrapType):String {
			switch(flowType) {
				case LEFT_TO_RIGHT_TOP_TO_BOTTOM:
				case LEFT_TO_RIGHT_BOTTOM_TO_TOP:
					return AlignUtil.RIGHT;
				case RIGHT_TO_LEFT_TOP_TO_BOTTOM:
				case RIGHT_TO_LEFT_BOTTOM_TO_TOP:
					return AlignUtil.LEFT;
				case TOP_TO_BOTTOM_LEFT_TO_RIGHT:
				case TOP_TO_BOTTOM_RIGHT_TO_LEFT:
					return AlignUtil.BOTTOM;
				case BOTTOM_TO_TOP_LEFT_TO_RIGHT:
				case BOTTOM_TO_TOP_RIGHT_TO_LEFT:
					return AlignUtil.TOP;
			}
			
			return null;
		}

		public static function getSecondaryAlignment(flowType:WrapType):String {
			switch(flowType) {
				case LEFT_TO_RIGHT_TOP_TO_BOTTOM:
				case RIGHT_TO_LEFT_TOP_TO_BOTTOM:
					return AlignUtil.TOP;
				case LEFT_TO_RIGHT_BOTTOM_TO_TOP:
				case RIGHT_TO_LEFT_BOTTOM_TO_TOP:
					return AlignUtil.BOTTOM;
				case TOP_TO_BOTTOM_LEFT_TO_RIGHT:
				case BOTTOM_TO_TOP_LEFT_TO_RIGHT:
					return AlignUtil.LEFT;
				case TOP_TO_BOTTOM_RIGHT_TO_LEFT:
				case BOTTOM_TO_TOP_RIGHT_TO_LEFT:
					return AlignUtil.RIGHT;
			}
			
			return null;
		}

		public static function getPrimaryWrap(flowType:WrapType):String {
			switch(flowType) {
				case LEFT_TO_RIGHT_TOP_TO_BOTTOM:
				case LEFT_TO_RIGHT_BOTTOM_TO_TOP:
					return AlignUtil.LEFT;
				case RIGHT_TO_LEFT_TOP_TO_BOTTOM:
				case RIGHT_TO_LEFT_BOTTOM_TO_TOP:
					return AlignUtil.RIGHT;
				case TOP_TO_BOTTOM_LEFT_TO_RIGHT:
				case TOP_TO_BOTTOM_RIGHT_TO_LEFT:
					return AlignUtil.TOP;
				case BOTTOM_TO_TOP_LEFT_TO_RIGHT:
				case BOTTOM_TO_TOP_RIGHT_TO_LEFT:
					return AlignUtil.BOTTOM;
			}
			
			return null;
		}

		public static function getSecondaryWrap(flowType:WrapType):String {
			switch(flowType) {
				case LEFT_TO_RIGHT_TOP_TO_BOTTOM:
				case RIGHT_TO_LEFT_TOP_TO_BOTTOM:
					return AlignUtil.BOTTOM;
				case LEFT_TO_RIGHT_BOTTOM_TO_TOP:
				case RIGHT_TO_LEFT_BOTTOM_TO_TOP:
					return AlignUtil.TOP;
				case TOP_TO_BOTTOM_LEFT_TO_RIGHT:
				case BOTTOM_TO_TOP_LEFT_TO_RIGHT:
					return AlignUtil.RIGHT;
				case TOP_TO_BOTTOM_RIGHT_TO_LEFT:
				case BOTTOM_TO_TOP_RIGHT_TO_LEFT:
					return AlignUtil.LEFT;
			}
			
			return null;
		}

		public static function getBaseRectangle(flowType:WrapType, bounds:Rectangle):Rectangle {
			switch(flowType) {
				case LEFT_TO_RIGHT_TOP_TO_BOTTOM:
				case TOP_TO_BOTTOM_LEFT_TO_RIGHT:
					return new Rectangle(bounds.left, bounds.top, 0, 0);
				case RIGHT_TO_LEFT_TOP_TO_BOTTOM:
				case TOP_TO_BOTTOM_RIGHT_TO_LEFT:
					return new Rectangle(bounds.right, bounds.top, 0, 0);
				case LEFT_TO_RIGHT_BOTTOM_TO_TOP:
				case BOTTOM_TO_TOP_LEFT_TO_RIGHT:
					return new Rectangle(bounds.left, bounds.bottom, 0, 0);
				case RIGHT_TO_LEFT_BOTTOM_TO_TOP:
				case BOTTOM_TO_TOP_RIGHT_TO_LEFT:
					return new Rectangle(bounds.right, bounds.bottom, 0, 0);
			}
			
			return null;
		}

		public static function getPrimarySize(flowType:WrapType, bounds:Rectangle):Number {
			switch(flowType) {
				case LEFT_TO_RIGHT_TOP_TO_BOTTOM:
				case RIGHT_TO_LEFT_TOP_TO_BOTTOM:
				case LEFT_TO_RIGHT_BOTTOM_TO_TOP:				case RIGHT_TO_LEFT_BOTTOM_TO_TOP:
					return bounds.width;
				case BOTTOM_TO_TOP_LEFT_TO_RIGHT:
				case TOP_TO_BOTTOM_LEFT_TO_RIGHT:
				case TOP_TO_BOTTOM_RIGHT_TO_LEFT:
				case BOTTOM_TO_TOP_RIGHT_TO_LEFT:
					return bounds.height;
			}
			
			return NaN;
		}

		public static function getFlowCompatableBounds(flowType:WrapType, bounds:Rectangle):Rectangle {
			
			bounds = bounds.clone();
			switch(flowType) {
				case LEFT_TO_RIGHT_BOTTOM_TO_TOP:
				case RIGHT_TO_LEFT_BOTTOM_TO_TOP:
					if(bounds.bottom == Number.POSITIVE_INFINITY) {
						bounds.bottom = 0;
					}
					bounds.top = bounds.bottom - MAXSIZE;
					break;
				case TOP_TO_BOTTOM_LEFT_TO_RIGHT:
				case BOTTOM_TO_TOP_LEFT_TO_RIGHT:
					if(bounds.left == Number.MIN_VALUE || bounds.left == Number.NEGATIVE_INFINITY) {
						bounds.left = 0;
					}
					bounds.right = Number.POSITIVE_INFINITY;
					break;
				case LEFT_TO_RIGHT_TOP_TO_BOTTOM:
				case RIGHT_TO_LEFT_TOP_TO_BOTTOM:
					if(bounds.top == Number.MIN_VALUE || bounds.top == Number.NEGATIVE_INFINITY) {
						bounds.top = 0;
					}
					bounds.bottom = Number.POSITIVE_INFINITY;
					break;
				case TOP_TO_BOTTOM_RIGHT_TO_LEFT:
				case BOTTOM_TO_TOP_RIGHT_TO_LEFT:
					if(bounds.right == Number.POSITIVE_INFINITY) {
						bounds.right = 0;
					}
					bounds.left = bounds.right - MAXSIZE;
					
					break;
			}
			
			return bounds;
		}
	}
}
