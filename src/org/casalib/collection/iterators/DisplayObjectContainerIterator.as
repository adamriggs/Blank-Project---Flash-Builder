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
package org.casalib.collection.iterators {
	import flash.display.DisplayObjectContainer;

	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * <code>DisplayObjectContainerIterator</code> is an <code>Iterator</code> that iterates over the children of a displayobject.
	 * 
	 * @author Jon Adams
	 * @version 09/22/10
	 * 
	 * @example
	 * 
	 * 
	 * <code>
		package {
			import org.casalib.collection.iterators.DisplayObjectContainerIterator;
		
			import flash.display.Sprite;
		
			public class MyExample extends Sprite {
		
				public function MyExample() {
					for (var i : int = 0; i < 20; i++) {
						addChild(getBox());
					}
					
					var iterator:DisplayObjectContainerIterator = new DisplayObjectContainerIterator(this);
					while(iterator.hasNext()) {
						var box:Sprite = iterator.next() as Sprite;
						box.x = iterator.currentIndex*22;
					}
				}
		
				public function getBox(w:Number = 20, h:Number = 20):Sprite {
					var box:Sprite = new Sprite();
					box.graphics.beginFill(0xFF0000, .5);
					box.graphics.drawRect(0, 0, w, h);
					box.graphics.endFill();
				
					box.graphics.lineStyle(0, 0);
					box.graphics.lineTo(w, h);
					box.graphics.moveTo(0, h);
					box.graphics.lineTo(w, 1);
				
					return box;
				}
			}
		}
	 * </code>
	 * 
	 * 
	 */
	public class DisplayObjectContainerIterator extends Iterator{

		/**
		 * Creates a new DisplayObjectContainerIterator;
		 * 
		 * @param displayObjectContainer The DisplayObjectContainer to be iterated over.
		 * @param index The position of iteration.
		 * @param isLooping: Indicates if the Iterator returns to the begining from the end and vice versa.
		 */
		public function DisplayObjectContainerIterator(displayObjectContainer:DisplayObjectContainer, index : int = -1, loop:Boolean = false) {
			super(displayObjectContainer, index, loop);
		}
		
		/**
		 * Retrieves the target and casts it as a DisplayObjectContainer.
		*/
		public function get displayObjectContainer():DisplayObjectContainer {
			return target as DisplayObjectContainer;
		}
		
		/**
		 * Retrieves the number of children.
		*/
		override public function getLength():uint{
			return displayObjectContainer.numChildren;
		}
		
		/**
		 * Retrieves the current child.
		*/
		override public function get current():* {
			return displayObjectContainer.getChildAt(currentIndex);
		}
	}
}
