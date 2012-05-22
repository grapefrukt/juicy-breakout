/**
 * RangeSlider.as
 * Keith Peters
 * version 0.9.10
 * 
 * Abstract base class for HRangeSlider and VRangeSlider.
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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Event(name="change", type="flash.events.Event")]
	public class RangeSlider extends Component
	{
		protected var _back:Sprite;
		protected var _highLabel:Label;
		protected var _highValue:Number = 100;
		protected var _labelMode:String = ALWAYS;
		protected var _labelPosition:String;
		protected var _labelPrecision:int = 0;
		protected var _lowLabel:Label;
		protected var _lowValue:Number = 0;
		protected var _maximum:Number = 100;
		protected var _maxHandle:Sprite;
		protected var _minimum:Number = 0;
		protected var _minHandle:Sprite;
		protected var _orientation:String = VERTICAL;
		protected var _tick:Number = 1;
		
		public static const ALWAYS:String = "always";
		public static const BOTTOM:String = "bottom";
		public static const HORIZONTAL:String = "horizontal";
		public static const LEFT:String = "left";
		public static const MOVE:String = "move";
		public static const NEVER:String = "never";
		public static const RIGHT:String = "right";
		public static const TOP:String = "top";
		public static const VERTICAL:String = "vertical";
		
		
		
		/**
		 * Constructor
		 * @param orientation Whether the slider will be horizontal or vertical.
		 * @param parent The parent DisplayObjectContainer on which to add this Slider.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function RangeSlider(orientation:String, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function = null)
		{
			_orientation = orientation;
			super(parent, xpos, ypos);
			if(defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
		}
		
		/**
		 * Initializes the component.
		 */
		protected override function init():void
		{
			super.init();
			if(_orientation == HORIZONTAL)
			{
				setSize(110, 10);
				_labelPosition = TOP;
			}
			else
			{
				setSize(10, 110);
				_labelPosition = RIGHT;
			}
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren():void
		{
			super.addChildren();
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			addChild(_back);
			
			_minHandle = new Sprite();
			_minHandle.filters = [getShadow(1)];
			_minHandle.addEventListener(MouseEvent.MOUSE_DOWN, onDragMin);
			_minHandle.buttonMode = true;
			_minHandle.useHandCursor = true;
			addChild(_minHandle);
			
			_maxHandle = new Sprite();
			_maxHandle.filters = [getShadow(1)];
			_maxHandle.addEventListener(MouseEvent.MOUSE_DOWN, onDragMax);
			_maxHandle.buttonMode = true;
			_maxHandle.useHandCursor = true;
			addChild(_maxHandle);			
			
			_lowLabel = new Label(this);
			_highLabel = new Label(this);
			_lowLabel.visible = (_labelMode == ALWAYS);
		}
		
		/**
		 * Draws the back of the slider.
		 */
		protected function drawBack():void
		{
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();
		}
		
		/**
		 * Draws the handles of the slider.
		 */
		protected function drawHandles():void
		{	
			_minHandle.graphics.clear();
			_minHandle.graphics.beginFill(Style.BUTTON_FACE);
			_maxHandle.graphics.clear();
			_maxHandle.graphics.beginFill(Style.BUTTON_FACE);
			if(_orientation == HORIZONTAL)
			{
				_minHandle.graphics.drawRect(1, 1, _height - 2, _height - 2);
				_maxHandle.graphics.drawRect(1, 1, _height - 2, _height - 2);
			}
			else
			{
				_minHandle.graphics.drawRect(1, 1, _width - 2, _width - 2);
				_maxHandle.graphics.drawRect(1, 1, _width - 2, _width - 2);
			}
			_minHandle.graphics.endFill();
			positionHandles();
		}
		
		/**
		 * Adjusts positions of handles when value, maximum or minimum have changed.
		 * TODO: Should also be called when slider is resized.
		 */
		protected function positionHandles():void
		{
			var range:Number;
			if(_orientation == HORIZONTAL)
			{
				range = _width - _height * 2;
				_minHandle.x = (_lowValue - _minimum) / (_maximum - _minimum) * range;
				_maxHandle.x = _height + (_highValue - _minimum) / (_maximum - _minimum) * range;
			}
			else
			{
				range = _height - _width * 2;
				_minHandle.y = _height - _width - (_lowValue - _minimum) / (_maximum - _minimum) * range;
				_maxHandle.y = _height - _width * 2 - (_highValue - _minimum) / (_maximum - _minimum) * range;
			}
			updateLabels();
		}
		
		/**
		 * Sets the text and positions the labels.
		 */
		protected function updateLabels():void
		{
			_lowLabel.text = getLabelForValue(lowValue);
			_highLabel.text = getLabelForValue(highValue);
			_lowLabel.draw();
			_highLabel.draw();

			if(_orientation == VERTICAL)
			{
				_lowLabel.y = _minHandle.y + (_width - _lowLabel.height) * 0.5;
				_highLabel.y = _maxHandle.y + (_width - _highLabel.height) * 0.5;
				if(_labelPosition == LEFT)
				{
					_lowLabel.x = -_lowLabel.width - 5;
					_highLabel.x = -_highLabel.width - 5;
				}
				else
				{
					_lowLabel.x = _width + 5;
					_highLabel.x = _width + 5;
				}
			}
			else
			{
				_lowLabel.x = _minHandle.x - _lowLabel.width + _height;
				_highLabel.x = _maxHandle.x;
				if(_labelPosition == BOTTOM)
				{
					_lowLabel.y = _height + 2;
					_highLabel.y = _height + 2;
				}
				else
				{
					_lowLabel.y = -_lowLabel.height;
					_highLabel.y = -_highLabel.height;
				}
				
			}
		}

		/**
		 * Generates a label string for the given value.
		 * @param value The number to create a label for.
		 */
		protected function getLabelForValue(value:Number):String
		{
			var str:String = (Math.round(value * Math.pow(10, _labelPrecision)) / Math.pow(10, _labelPrecision)).toString();
			if(_labelPrecision > 0)
			{
				var decimal:String = str.split(".")[1] || "";
				if(decimal.length == 0) str += ".";
				for(var i:int = decimal.length; i < _labelPrecision; i++)
				{
					str += "0";
				}
			}
			return str;
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
			drawBack();
			drawHandles();
		}
		

		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseDown handler for the low value handle. Starts dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDragMin(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMinSlide);
			if(_orientation == HORIZONTAL)
			{
				_minHandle.startDrag(false, new Rectangle(0, 0, _maxHandle.x - _height, 0));
			}
			else
			{
				_minHandle.startDrag(false, new Rectangle(0, _maxHandle.y + _width, 0, _height - _maxHandle.y - _width * 2));
			}
			if(_labelMode == MOVE)
			{
				_lowLabel.visible = true;
				_highLabel.visible = true;
			}
		}
		
		/**
		 * Internal mouseDown handler for the high value handle. Starts dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDragMax(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMaxSlide);
			if(_orientation == HORIZONTAL)
			{
				_maxHandle.startDrag(false, new Rectangle(_minHandle.x + _height, 0, _width - _height - _minHandle.x - _height, 0));
			}
			else
			{
				_maxHandle.startDrag(false, new Rectangle(0, 0, 0, _minHandle.y - _width));
			}
			if(_labelMode == MOVE)
			{
				_lowLabel.visible = true;
				_highLabel.visible = true;
			}
		}
		
		/**
		 * Internal mouseUp handler. Stops dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDrop(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMinSlide);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMaxSlide);
			stopDrag();
			if(_labelMode == MOVE)
			{
				_lowLabel.visible = false;
				_highLabel.visible = false;
			}
		}
		
		/**
		 * Internal mouseMove handler for when the low value handle is being moved.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMinSlide(event:MouseEvent):void
		{
			var oldValue:Number = _lowValue;
			if(_orientation == HORIZONTAL)
			{
				_lowValue = _minHandle.x / (_width - _height * 2) * (_maximum - _minimum) + _minimum;
			}
			else
			{
				_lowValue = (_height - _width - _minHandle.y) / (height - _width * 2) * (_maximum - _minimum) + _minimum;
			}
			if(_lowValue != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			updateLabels();
		}

		/**
		 * Internal mouseMove handler for when the high value handle is being moved.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMaxSlide(event:MouseEvent):void
		{
			var oldValue:Number = _highValue;
			if(_orientation == HORIZONTAL)
			{
				_highValue = (_maxHandle.x - _height) / (_width - _height * 2) * (_maximum - _minimum) + _minimum;
			}
			else
			{
				_highValue = (_height - _width * 2 - _maxHandle.y) / (_height - _width * 2) * (_maximum - _minimum) + _minimum;
			}
			if(_highValue != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			updateLabels();
		}
		
		/**
		 * Gets / sets the minimum value of the slider.
		 */
		public function set minimum(value:Number):void
		{
			_minimum = value;
			_maximum = Math.max(_maximum, _minimum);
			_lowValue = Math.max(_lowValue, _minimum);
			_highValue = Math.max(_highValue, _minimum);
			positionHandles();
		}
		public function get minimum():Number
		{
			return _minimum;
		}

		/**
		 * Gets / sets the maximum value of the slider.
		 */
		public function set maximum(value:Number):void
		{
			_maximum = value;
			_minimum = Math.min(_minimum, _maximum);
			_lowValue = Math.min(_lowValue, _maximum);
			_highValue = Math.min(_highValue, _maximum);
			positionHandles();
		}
		public function get maximum():Number
		{
			return _maximum;
		}

		/**
		 * Gets / sets the low value of this slider.
		 */
		public function set lowValue(value:Number):void
		{
			_lowValue = value;
			_lowValue = Math.min(_lowValue, _highValue);
			_lowValue = Math.max(_lowValue, _minimum);
			positionHandles();
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function get lowValue():Number
		{
			return Math.round(_lowValue / _tick) * _tick;
		}

		/**
		 * Gets / sets the high value for this slider.
		 */
		public function set highValue(value:Number):void
		{
			_highValue = value;
			_highValue = Math.max(_highValue, _lowValue);
			_highValue = Math.min(_highValue, _maximum);
			positionHandles();
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function get highValue():Number
		{
			return Math.round(_highValue / _tick) * _tick;
		}

		/**
		 * Sets / gets when the labels will appear. Can be "never", "move", or "always"
		 */
		public function set labelMode(value:String):void
		{
			_labelMode = value;
			_highLabel.visible = (_labelMode == ALWAYS);
			_lowLabel.visible = (_labelMode == ALWAYS);
		}
		public function get labelMode():String
		{
			return _labelMode;
		}

		/**
		 * Sets / gets where the labels will appear. "left" or "right" for vertical sliders, "top" or "bottom" for horizontal.
		 */
		public function set labelPosition(value:String):void
		{
			_labelPosition = value;
			updateLabels();
		}
		public function get labelPosition():String
		{
			return _labelPosition;
		}

		/**
		 * Sets / gets how many decimal points of precisions will be displayed on the labels.
		 */
		public function set labelPrecision(value:int):void
		{
			_labelPrecision = value;
			updateLabels();
		}
		public function get labelPrecision():int
		{
			return _labelPrecision;
		}

		/**
		 * Gets / sets the tick value of this slider. This round the value to the nearest multiple of this number. 
		 */
		public function set tick(value:Number):void
		{
			_tick = value;
			updateLabels();
		}
		public function get tick():Number
		{
			return _tick;
		}


	}
}