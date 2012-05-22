/**
 * VBox.as
 * Keith Peters
 * version 0.9.10
 * 
 * A layout container for vertically aligning other components.
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
 
package com.bit101.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	[Event(name="resize", type="flash.events.Event")]
	public class HBox extends Component
	{
		protected var _spacing:Number = 5;
		private var _alignment:String = NONE;
		
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const MIDDLE:String = "middle";
		public static const NONE:String = "none";
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this PushButton.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function HBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
		{
			super(parent, xpos, ypos);
		}
		
        /**
         * Override of addChild to force layout;
         */
        override public function addChild(child:DisplayObject) : DisplayObject
        {
            super.addChild(child);
            child.addEventListener(Event.RESIZE, onResize);
            draw();
            return child;
        }

        /**
         * Override of addChildAt to force layout;
         */
        override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
        {
            super.addChildAt(child, index);
            child.addEventListener(Event.RESIZE, onResize);
            draw();
            return child;
        }

        /**
         * Override of removeChild to force layout;
         */
        override public function removeChild(child:DisplayObject):DisplayObject
        {
            super.removeChild(child);
            child.removeEventListener(Event.RESIZE, onResize);
            draw();
            return child;
        }

        /**
         * Override of removeChild to force layout;
         */
        override public function removeChildAt(index:int):DisplayObject
        {
            var child:DisplayObject = super.removeChildAt(index);
            child.removeEventListener(Event.RESIZE, onResize);
            draw();
            return child;
        }

		protected function onResize(event:Event):void
		{
			invalidate();
		}
		
		protected function doAlignment():void
		{
			if(_alignment != NONE)
			{
				for(var i:int = 0; i < numChildren; i++)
				{
					var child:DisplayObject = getChildAt(i);
					if(_alignment == TOP)
					{
						child.y = 0;
					}
					else if(_alignment == BOTTOM)
					{
						child.y = _height - child.height;
					}
					else if(_alignment == MIDDLE)
					{
						child.y = (_height - child.height) / 2;
					}
				}
			}
		}
		
		/**
		 * Draws the visual ui of the component, in this case, laying out the sub components.
		 */
		override public function draw() : void
		{
			_width = 0;
			_height = 0;
			var xpos:Number = 0;
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				child.x = xpos;
				xpos += child.width;
				xpos += _spacing;
				_width += child.width;
				_height = Math.max(_height, child.height);
			}
			doAlignment();
			_width += _spacing * (numChildren - 1);
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Gets / sets the spacing between each sub component.
		 */
		public function set spacing(s:Number):void
		{
			_spacing = s;
			invalidate();
		}
		public function get spacing():Number
		{
			return _spacing;
		}

		/**
		 * Gets / sets the vertical alignment of components in the box.
		 */
		public function set alignment(value:String):void
		{
			_alignment = value;
			invalidate();
		}
		public function get alignment():String
		{
			return _alignment;
		}
	}
}