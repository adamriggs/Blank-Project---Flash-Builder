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
	import org.casalib.util.NumberUtil;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * Base iterator class. Iterator is not designed to be used on its own and needs to be extended to function..
	 * 
	 * @author Jon Adams
	 * @version 09/22/10
	 */
	public class Iterator extends EventDispatcher implements IIterator{

		private var _target:Object;		private var _currentIndex:int;
		public var loop:Boolean;
		private var origonalIndex:int;

		/**
		 * Creates a new Iterator;
		 * 
		 * @param target The Object to be iterated over.
		 * @param index The position of iteration.
		 * @param isLooping: Indicates if the Iterator returns to the begining from the end and vice versa.
		 */
		public function Iterator(target:Object, index : int = -1, loop:Boolean = false) {
			_target = target;
			currentIndex = origonalIndex = index;
			this.loop = loop;
		}
		
		/**
		 * Retrieves the object defined as target in the class' constructor.
		*/
		public function get target():Object {
			return _target;
		}
		
		/**
		 * Determines if an element exists in the first posotion.
		*/
		public function hasFirst():Boolean {
			return getLength() > 0;
		}

		public function getLength():uint {
			return 0;
		}

		/**
		 * Determines if an element exists in the last posotion.
		*/
		public function hasLast():Boolean {
			return hasFirst();
		}
		
		/**
		 * Determines if an element exists in the next posotion.
		*/
		public function hasNext():Boolean {
			if(loop){
				return hasFirst();
			}
			return currentIndex + 1 < getLength();
		}
		
		/**
		 * Determines if an element exists in the previous posotion.
		*/
		public function hasPrevious():Boolean {
			if(loop){
				return hasFirst();
			}
			return currentIndex -1 > -1;
		}
		
		/**
		 * Changes current to and returns the next element. 
		*/
		public function next():* {
			if(hasNext()){
				currentIndex++;
				currentIndex = NumberUtil.loopIndex(currentIndex, getLength());
				return current;
			}
			return null;
		}
		
		/**
		 * Changes current to and returns the previous element. 
		*/
		public function previous():* {
			if(hasPrevious()){
				currentIndex--;
				currentIndex = NumberUtil.loopIndex(currentIndex, getLength());
				return current;
			}
			return null;
		}
		
		/**
		 * Changes current to and returns the first element. 
		*/
		public function first():* {
			if(hasFirst()){
				currentIndex = 0;
				return current;
			}
			return null;
		}
		
		/**
		 * Changes current to and returns the last element. 
		*/
		public function last():* {
			if(hasFirst()){
				currentIndex = getLength();
				return current;
			}
			return null;
		}
		
		/**
		 * Returns the current element. 
		*/
		public function get current():* {
			return undefined;
		}
		
		/**
		 * Returns the current index. 
		*/
		public function get currentIndex():int {
			return _currentIndex;
		}
		
		/**
		 * Sets the current index and dispatches a change. 
		*/
		public function set currentIndex(index:int):void {
			_currentIndex = index < getLength() ? index : -1;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function reset():void {
			currentIndex = origonalIndex
		}
	}
}
