package org.casalib.layout.positioning 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	/**
	 * @author Jon Adams
	 */
	/**
	 * @author Jon Adams
	 */
	public interface ILayoutMember {
		function position(targetCoordinateSpace:DisplayObjectContainer, memberBounds:Rectangle, snap:Boolean):void
		function getBounds(targetCoordinateSpace:DisplayObjectContainer):Rectangle;
	}
	
}
