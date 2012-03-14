/*
	CASA Lib for ActionScript 3.0
	Copyright (c) 2010, Aaron Clinger & Contributors of CASA Lib
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	- Redistributions of source code must retain the above copyright notice,
	  this list of conditions and the following disclaimer.
	
	- Redistributions in binary form must reproduce the above copyright notice,
	  this list of conditions and the following disclaimer in the documentation
	  and/or other materials provided with the distribution.
	
	- Neither the name of the CASA Lib nor the names of its contributors
	  may be used to endorse or promote products derived from this software
	  without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/
package org.casalib.layout {
	import org.casalib.collection.iterators.DisplayObjectContainerIterator;
	import org.casalib.layout.positioning.ILayoutMember;
	import org.casalib.layout.positioning.LayoutMember;
	import org.casalib.layout.positioning.SubLayoutMember;
	import org.casalib.layout.positioning.WrapType;
	import org.casalib.layout.positioning.algorithm.Line;
	import org.casalib.layout.positioning.algorithm.PositioningAlgorithm;
	import org.casalib.util.ArrayUtil;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	/**
	 * Organises DisplayObjects within a bounding Rectangle according to a 
	 * PositioningAlgorithm and takes into account wrapping to rows or columns.  
	 *  
	 * @author Jon Adams
	 * @version 10/1/10
	 * 
	 */
	public class Layout {

		private static const DEFAULT_BOUNDS:Rectangle = new Rectangle(0, 0, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);		private static const DEFAULT_POSITIONING_ALGORITHM:PositioningAlgorithm = Line.WRAP;		private static const DEFAULT_WRAP_TYPE:WrapType = WrapType.LEFT_TO_RIGHT_TOP_TO_BOTTOM;
		
		private var _targetCoordinateSpace:DisplayObjectContainer;
		private var _bounds:Rectangle = DEFAULT_BOUNDS;
		private var _positioningAlgorithm:PositioningAlgorithm;
		private var _wrapType:WrapType;
		private var _snap:Boolean;
		
		private var _layoutMembers:Array;

		/**
		 * Creates a Layout.
		 * 
		 * @param targetCoordinateSpace: The DisplayObject object that defines the coordinate system to use. This is required because not all display objects will necessarily reside in the same DisplayObjectContainer.
		 */
		public function Layout(targetCoordinateSpace:DisplayObjectContainer) {
			this.targetCoordinateSpace = targetCoordinateSpace;
			
			bounds = DEFAULT_BOUNDS;
			positioningAlgorithm = DEFAULT_POSITIONING_ALGORITHM;
			wrapType = DEFAULT_WRAP_TYPE;
			
			
			this.snap = snap;
			clearMembers();
		}
		
		/**
		 * A convience method to position all children in a container
		 * @param target: The DisplayObjectContainer object that defines the children to position.
		 * @param bounds: The Rectangle that defines the bounds
		 * @param positioningAlgorithm: The PositioningAlgorithm that determines where each DisplayObject is positioned.
		 * @param wrapType:
		 * @param snap:
		 */
		public static function position(target:DisplayObjectContainer, bounds:Rectangle = null, positioningAlgorithm:PositioningAlgorithm = null, wrapType:WrapType = null, snap:Boolean = false):void {
			var layout:Layout = new Layout(target);
			
			if(positioningAlgorithm){
				layout.positioningAlgorithm = positioningAlgorithm;
			}
			
			if(bounds){
				layout.bounds = bounds;
			}
			
			if(layout.wrapType){
				layout.wrapType = wrapType;
			}
			
			layout.snap = snap;
			
			layout.addChildren(target);
			layout.position();
		}

		public function addChildren(displayObjectContainer:DisplayObjectContainer, top:Number = 0, right:Number = 0, bottom:Number = 0, left:Number = 0):void {
			var iterator:DisplayObjectContainerIterator = new DisplayObjectContainerIterator(displayObjectContainer);
			
			while(iterator.hasNext()){
				addDisplayObject(iterator.next() as DisplayObject, top, right, bottom, left);
			}
		}

		public function addDisplayObject(displayObject:DisplayObject, top:Number = 0, right:Number = 0, bottom:Number = 0, left:Number = 0):Boolean {
			if(!ArrayUtil.getItemByKey(_layoutMembers, "displayObject", displayObject)){

				var layoutMember:LayoutMember = new LayoutMember(displayObject, top, bottom, left, right);
				
				_layoutMembers.push(layoutMember);
				
				return true;
			}
			
			return false;
		}

		public function removeDisplayObject(displayObject:DisplayObject):void {
			var matches:Array = ArrayUtil.getItemsByKey(_layoutMembers, "displayObject", displayObject);
			ArrayUtil.removeItems(_layoutMembers, matches);
		}

		public function addLayout(layout:Layout, top:Number = 0, right:Number = 0, bottom:Number = 0, left:Number = 0):Boolean {
			if(!ArrayUtil.getItemByKey(_layoutMembers, "layout", layout)){

				var layoutMember:SubLayoutMember = new SubLayoutMember(layout, top, bottom, left, right);
				
				_layoutMembers.push(layoutMember);
				
				return true;
			}
			
			return false;
		}

		public function removeLayout(layout:Layout):void {
			var matches:Array = ArrayUtil.getItemsByKey(_layoutMembers, "layout", layout);
			ArrayUtil.removeItems(_layoutMembers, matches);
		}

		public function clearMembers():void {
			_layoutMembers = [];
		}
		
		public function position():Rectangle {
			return positioningAlgorithm.position(targetCoordinateSpace, layoutMembers, bounds, wrapType, snap);
		}
		
		public function get layoutMembers():Array {
			return _layoutMembers;		}

		public function get members():Array {
			var displayObjects:Array = [];
			
			for each (var member : ILayoutMember in _layoutMembers) {
				switch(getQualifiedClassName(member)){
					case getQualifiedClassName(LayoutMember):
						var layoutMember:LayoutMember = member as LayoutMember;						displayObjects.push(layoutMember.displayObject);
						break;//					case getQualifiedClassName(SubLayoutMember):
//						var subLayoutMember:SubLayoutMember = member as SubLayoutMember;//						displayObjects.concat(subLayoutMember.layout.members);
//						break;
					default:
				}
			}
			
			return displayObjects;
		}
		
		public function get bounds():Rectangle {
			return _bounds;
		}
		
		public function set bounds(bounds:Rectangle):void {
			_bounds = bounds;
		}
		
		public function get targetCoordinateSpace():DisplayObjectContainer {
			return _targetCoordinateSpace;
		}
		
		public function set targetCoordinateSpace(targetCoordinateSpace:DisplayObjectContainer):void {
			_targetCoordinateSpace = targetCoordinateSpace;
		}
		
		public function get wrapType():WrapType {
			return _wrapType;
		}
		
		public function set wrapType(wrapType:WrapType):void {
			_wrapType = wrapType;
		}
		
		public function get snap():Boolean {
			return _snap;
		}
		
		public function set snap(snap:Boolean):void {
			_snap = snap;
		}
		
		public function get positioningAlgorithm():PositioningAlgorithm {
			return _positioningAlgorithm;
		}
		
		public function set positioningAlgorithm(positioningAlgorithm:PositioningAlgorithm):void {
			_positioningAlgorithm = positioningAlgorithm;
		}
	}
}
