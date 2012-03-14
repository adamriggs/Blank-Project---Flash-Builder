package org.casalib.layout.positioning.algorithm 
{
	import org.casalib.collection.iterators.ArrayIterator;
	import org.casalib.layout.positioning.ILayoutMember;
	import org.casalib.layout.positioning.WrapType;

	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	/**
	 * @author Jon Adams
	 */
	public class PositioningAlgorithm {
		public function position(targetCoordinateSpace:DisplayObjectContainer, layoutMembers:Array, bounds:Rectangle, wrapType:WrapType, snap:Boolean):Rectangle {
			
			bounds = WrapType.getFlowCompatableBounds(wrapType, bounds);
			
			var placedRectangles:Rectangle = WrapType.getBaseRectangle(wrapType, bounds);
			var lastRectangle:Rectangle = placedRectangles;
			
			var iterator:ArrayIterator = new ArrayIterator(layoutMembers);
			while(iterator.hasNext()) {
				var member:ILayoutMember = iterator.next() as ILayoutMember;
				
				var memberBounds:Rectangle = getNextPosition(wrapType, bounds, member.getBounds(targetCoordinateSpace), lastRectangle, placedRectangles);
				
				
				lastRectangle = memberBounds;
				placedRectangles = placedRectangles.union(memberBounds);
				
				member.position(targetCoordinateSpace, memberBounds, snap);
			}
			
			return placedRectangles;
		}

		internal function getNextPosition(wrapType:WrapType, bounds:Rectangle, memberBounds:Rectangle, lastRectangle:Rectangle, placedRectangles:Rectangle):Rectangle {
			return bounds;
		}
	}
}
