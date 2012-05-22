/**
 * IndicatorLight.as
 * Keith Peters
 * version 0.9.10
 * 
 * An indicator light that can be turned on, off, or set to flash.
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
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	public class IndicatorLight extends Component
	{
		protected var _color:uint;
		protected var _lit:Boolean = false;
		protected var _label:Label;
		protected var _labelText:String = "";
		protected var _lite:Shape;
		protected var _timer:Timer;
		
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this CheckBox.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param color The color of this light.
		 * @param label String containing the label for this component.
		 */
		public function IndicatorLight(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0, color:uint = 0xff0000, label:String = "")
		{
			_color = color;
			_labelText = label;
			super(parent, xpos, ypos);
		}

		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			_timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		/**
		 * Creates the children for this component
		 */
		override protected function addChildren():void
		{
			_lite = new Shape();
			addChild(_lite);
			
			_label = new Label(this, 0, 0, _labelText);
			draw();
		}
		
		/**
		 * Draw the light.
		 */
		protected function drawLite():void
		{
			var colors:Array;
			if(_lit)
			{
				colors = [0xffffff, _color];
			}
			else
			{
				colors = [0xffffff, 0];
			}
			
			_lite.graphics.clear();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(10, 10, 0, -2.5, -2.5);
			_lite.graphics.beginGradientFill(GradientType.RADIAL, colors, [1, 1], [0, 255], matrix);
			_lite.graphics.drawCircle(5, 5, 5);
			_lite.graphics.endFill();
		}
		
		
		
		///////////////////////////////////
		// event handler
		///////////////////////////////////
		
		/**
		 * Internal timer handler.
		 * @param event The TimerEvent passed by the system.
		 */
		protected function onTimer(event:TimerEvent):void
		{
			_lit = !_lit;
			draw();
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			drawLite();
			
			_label.text = _labelText;
			_label.x = 12;
			_label.y = (10 - _label.height) / 2;
			_width = _label.width + 12;
			_height = 10;
		}
		
		/**
		 * Causes the light to flash on and off at the specified interval (milliseconds). A value less than 1 stops the flashing.
		 */
		public function flash(interval:int = 500):void
		{
			if(interval < 1)
			{
				_timer.stop();
				isLit = false;
				return;
			}
			_timer.delay = interval;
			_timer.start();
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets or gets whether or not the light is lit.
		 */
		public function set isLit(value:Boolean):void
		{
			_timer.stop();
			_lit = value;
			drawLite();
		}
		public function get isLit():Boolean
		{
			return _lit;
		}
		
		/**
		 * Sets / gets the color of this light (when lit).
		 */
		public function set color(value:uint):void
		{
			_color = value;
			draw();
		}
		public function get color():uint
		{
			return _color;
		}
		
		/**
		 * Returns whether or not the light is currently flashing.
		 */
		public function get isFlashing():Boolean
		{
			return _timer.running;
		}
		
		/**
		 * Sets / gets the label text shown on this component.
		 */
		public function set label(str:String):void
		{
			_labelText = str;
			draw();
		}
		public function get label():String
		{
			return _labelText;
		}
		

	}
}