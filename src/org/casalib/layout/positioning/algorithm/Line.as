package org.casalib.layout.positioning.algorithm {
	import org.casalib.layout.positioning.WrapType;
	import org.casalib.util.AlignUtil;

	import flash.geom.Rectangle;

	/**
	 * @author Jon Adams
	 */
	public class Line extends PositioningAlgorithm {

		public static const WRAP:Line = new Line();

		override internal function getNextPosition(flowType:WrapType, bounds:Rectangle, memberBounds:Rectangle, lastRectangle:Rectangle, placedRectangles:Rectangle):Rectangle {
			memberBounds = AlignUtil.alignRectangle(WrapType.getPrimaryAlignment(flowType), memberBounds, lastRectangle, false, true);
			memberBounds = AlignUtil.alignRectangle(WrapType.getSecondaryAlignment(flowType), memberBounds, lastRectangle, false, false);

			if(bounds.containsRect(memberBounds) == false) {
				memberBounds = AlignUtil.alignRectangle(WrapType.getPrimaryWrap(flowType), memberBounds, bounds, false, false);
				memberBounds = AlignUtil.alignRectangle(WrapType.getSecondaryWrap(flowType), memberBounds, placedRectangles, false, true);
			}
			
			return memberBounds;
		}
	}
}
