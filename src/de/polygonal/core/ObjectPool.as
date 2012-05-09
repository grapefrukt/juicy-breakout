/**
 * Object Pool V1.0
 * Copyright (c) 2008 Michael Baczynski, http://www.polygonal.de
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package de.polygonal.core 
{
	public class ObjectPool
	{
		private var _obj:Class;
		
		private var _initSize:int;
		private var _currSize:int;
		private var _usageCount:int;
		
		private var _grow:Boolean = true;
		
		private var _head:ObjNode;
		private var _tail:ObjNode;
		
		private var _emptyNode:ObjNode;
		private var _allocNode:ObjNode;
		
		/**
		 * Creates a new object pool.
		 * 
		 * @param grow If true, the pool grows the first time it becomes empty.
		 */
		public function ObjectPool(grow:Boolean = false)
		{
			_grow = grow;
		}
		
		/**
		 * Unlock all ressources for the garbage collector.
		 */
		public function deconstruct():void
		{
			var node:ObjNode = _head;
			var t:ObjNode;
			while (node)
			{
				t = node.next;
				node.next = null;
				node.data = null;
				node = t;
			}
			
			_head = _tail = _emptyNode = _allocNode = null;
		}
		
		/**
		 * The pool size.
		 */
		public function get size():int
		{
			return _currSize;
		}
		
		/**
		 * The total number of 'checked out' objects currently in use.
		 */
		public function get usageCount():int
		{
			return _usageCount;
		}
		
		/**
		 * The total number of unused thus wasted objects. Use the purge()
		 * method to compact the pool.
		 * 
		 * @see #purge
		 */
		public function get wasteCount():int
		{
			return _currSize - _usageCount;	
		}
		
		/**
		 * Get the next available object from the pool or put it back for the
		 * next use. If the pool is empty and resizable, an error is thrown.
		 */
		public function get object():*
		{
			if (_usageCount == _currSize)
			{
				if (_grow)
				{
					_currSize += _initSize;
					
					var n:ObjNode = _tail;
					var t:ObjNode = _tail;
					
					var node:ObjNode;
					for (var i:int = 0; i < _initSize; i++)
					{
						node = new ObjNode();
						node.data = new _obj();
						
						t.next = node;
						t = node; 
					}
					
					_tail = t;
					
					_tail.next = _emptyNode = _head;
					_allocNode = n.next;
					return object;
				}
 				else
					throw new Error("object pool exhausted");
			}
			else
			{
				var o:* = _allocNode.data;
				_allocNode.data = null;
				_allocNode = _allocNode.next;
				_usageCount++;
				return o;
			}
		}
		
		/**
		 * @private
		 */
		public function set object(o:*):void
		{
			if (_usageCount > 0)
			{
				_usageCount--;
				_emptyNode.data = o;
				_emptyNode = _emptyNode.next;
			}
		}
		
		/**
		 * Allocate the pool by creating all objects from the given class.
		 * 
		 * @param C    The class to instantiate for each object in the pool.
		 * @param size The number of objects to create.
		 */
		public function allocate(C:Class, size:uint):void
		{
			deconstruct();
			
			_obj = C;
			_initSize = _currSize = size;
			
			_head = _tail = new ObjNode();
			_head.data = new _obj();
			
			var n:ObjNode;
			
			for (var i:int = 1; i < _initSize; i++)
			{
				n = new ObjNode();
				n.data = new _obj();
				n.next = _head;
				_head = n;
			}
			
			_emptyNode = _allocNode = _head;
			_tail.next = _head;
		}
		
		/**
		 * Helper method for applying a function to all objects in the pool.
		 * 
		 * @param func The function's name.
		 * @param args The function's arguments.
		 */
		public function initialize(func:String, args:Array):void
		{
			var n:ObjNode = _head;
			while (n)
			{
				n.data[func].apply(n.data, args);
				if (n == _tail) break;
				n = n.next;	
			}
		}
		
		/**
		 * Remove all unused objects from the pool. If the number of remaining
		 * used objects is smaller than the initial capacity defined by the
		 * allocate() method, new objects are created to refill the pool. 
		 */
		public function purge():void
		{
			var i:int;
			var node:ObjNode;
			
			if (_usageCount == 0)
			{
				if (_currSize == _initSize)
					return;
					
				if (_currSize > _initSize)
				{
					i = 0; 
					node = _head;
					while (++i < _initSize)
						node = node.next;	
					
					_tail = node;
					_allocNode = _emptyNode = _head;
					
					_currSize = _initSize;
					return;	
				}
			}
			else
			{
				var a:Array = [];
				node =_head;
				while (node)
				{
					if (!node.data) a[int(i++)] = node;
					if (node == _tail) break;
					node = node.next;	
				}
				
				_currSize = a.length;
				_usageCount = _currSize;
				
				_head = _tail = a[0];
				for (i = 1; i < _currSize; i++)
				{
					node = a[i];
					node.next = _head;
					_head = node;
				}
				
				_emptyNode = _allocNode = _head;
				_tail.next = _head;
				
				if (_usageCount < _initSize)
				{
					_currSize = _initSize;
					
					var n:ObjNode = _tail;
					var t:ObjNode = _tail;
					var k:int = _initSize - _usageCount;
					for (i = 0; i < k; i++)
					{
						node = new ObjNode();
						node.data = new _obj();
						
						t.next = node;
						t = node; 
					}
					
					_tail = t;
					
					_tail.next = _emptyNode = _head;
					_allocNode = n.next;
					
				}
			}
		}
	}
}

internal class ObjNode
{
	public var next:ObjNode;
	
	public var data:*;
}