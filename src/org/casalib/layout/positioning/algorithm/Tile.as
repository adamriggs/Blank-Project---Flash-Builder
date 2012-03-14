package org.casalib.layout.positioning.algorithm {
	import org.casalib.collection.iterators.ArrayIterator;
	import org.casalib.layout.positioning.ILayoutMember;
	import org.casalib.layout.positioning.WrapType;
	import org.casalib.util.AlignUtil;

	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	/**
	 * @author Jon Adams
	 */
	public class Tile extends Line {

		private var alignment:String;
		private var cellSize:Number;

		public function Tile(alignment:String = AlignUtil.TOP_LEFT) {
			this.alignment = alignment;
		}
		
		override public function position(targetCoordinateSpace:DisplayObjectContainer, layoutMembers:Array, bounds:Rectangle, wrapType:WrapType, snap:Boolean):Rectangle {
			
			calculateCellSize(targetCoordinateSpace, layoutMembers);
			
			bounds = WrapType.getFlowCompatableBounds(wrapType, bounds);
			var placedRectangles:Rectangle = WrapType.getBaseRectangle(wrapType, bounds);
			var lastRectangle:Rectangle = placedRectangles;
			
			var iterator:ArrayIterator = new ArrayIterator(layoutMembers);
			while(iterator.hasNext()) {
				var cellBounds:Rectangle = new Rectangle(0, 0, cellSize, cellSize);
				
				var member:ILayoutMember = iterator.next() as ILayoutMember;
				
				cellBounds = getNextPosition(wrapType, bounds, cellBounds.clone(), lastRectangle, placedRectangles);
				lastRectangle = cellBounds.clone();
				placedRectangles = placedRectangles.union(cellBounds);
				
				var memberBounds:Rectangle = member.getBounds(targetCoordinateSpace);
				
				memberBounds = AlignUtil.alignRectangle(alignment, memberBounds, cellBounds);
				
				member.position(targetCoordinateSpace, memberBounds, snap);
			}
			
			return placedRectangles;
		}

		private function calculateCellSize(targetCoordinateSpace:DisplayObjectContainer, layoutMembers:Array):void {
			cellSize = 0;
			
			var iterator:ArrayIterator = new ArrayIterator(layoutMembers);
			while(iterator.hasNext()) {
				
				var member:ILayoutMember = iterator.next() as ILayoutMember;
				var memberBounds:Rectangle = member.getBounds(targetCoordinateSpace);
				
				cellSize = cellSize > memberBounds.width ? cellSize : memberBounds.width;
				cellSize = cellSize > memberBounds.height ? cellSize : memberBounds.height;
			}
		}
	}
}
