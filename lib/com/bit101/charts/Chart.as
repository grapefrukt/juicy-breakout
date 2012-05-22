/**
 * Chart.as
 * Keith Peters
 * version 0.9.10
 * 
 * A base chart component for graphing an array of numeric data.
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

package com.bit101.charts
{
	
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	public class Chart extends Component
	{
		protected var _data:Array;
		protected var _chartHolder:Shape;
		protected var _maximum:Number = 100;
		protected var _minimum:Number = 0;
		protected var _autoScale:Boolean = true;
		protected var _maxLabel:Label;
		protected var _minLabel:Label;
		protected var _showScaleLabels:Boolean = false;
		protected var _labelPrecision:int = 0;
		protected var _panel:Panel;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Label.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param data The array of numeric values to graph.
		 */
		public function Chart(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Array=null)
		{
			_data = data;
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		protected override function init() : void
		{
			super.init();
			setSize(200, 100);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren() : void
		{
			super.addChildren();
			_panel = new Panel(this);
			
			_chartHolder = new Shape();
			_panel.content.addChild(_chartHolder);
			
			_maxLabel = new Label();
			_minLabel = new Label();
		}
		
		/**
		 * Graphs the numeric data in the chart. Override in subclasses.
		 */
		protected function drawChart():void
		{
		}
		
		/**
		 * Gets the highest value of the numbers in the data array.
		 */
		protected function getMaxValue():Number
		{
			if(!_autoScale) return _maximum;
			var maxValue:Number = Number.NEGATIVE_INFINITY;
			for(var i:int = 0; i < _data.length; i++)
			{
				if(_data[i] != null)
				{
					maxValue = Math.max(_data[i], maxValue);
				}
			}
			return maxValue;
		}
		
		/**
		 * Gets the lowest value of the numbers in the data array.
		 */
		protected function getMinValue():Number
		{
			if(!_autoScale) return _minimum;
			var minValue:Number = Number.POSITIVE_INFINITY;
			for(var i:int = 0; i < _data.length; i++)
			{
				if(_data[i] != null)
				{
					minValue = Math.min(_data[i], minValue);
				}
			}
			return minValue;
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		public override function draw() : void
		{
			super.draw();
			_panel.setSize(width, height);
			_panel.draw();
			_chartHolder.graphics.clear();
			if(_data != null)
			{
				drawChart();
			
				var mult:Number = Math.pow(10, _labelPrecision);
				var maxVal:Number = Math.round(maximum * mult) / mult;
				_maxLabel.text = maxVal.toString();
				_maxLabel.draw();
				_maxLabel.x = -_maxLabel.width - 5;
				_maxLabel.y = -_maxLabel.height * 0.5; 
				
				var minVal:Number = Math.round(minimum * mult) / mult;
				_minLabel.text = minVal.toString();
				_minLabel.draw();
				_minLabel.x = -_minLabel.width - 5;
				_minLabel.y = height - _minLabel.height * 0.5;
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
				
		/**
		 * Sets/gets the data array.
		 */
		public function set data(value:Array):void
		{
			_data = value;
			invalidate();
		}
		public function get data():Array
		{
			return _data;
		}

		/**
		 * Sets/gets the maximum value of the graph. Only used if autoScale is false.
		 */
		public function set maximum(value:Number):void
		{
			_maximum = value;
			invalidate();
		}
		public function get maximum():Number
		{
			if(_autoScale) return getMaxValue();
			return _maximum;
		}

		/**
		 * Sets/gets the minimum value of the graph. Only used if autoScale is false.
		 */
		public function set minimum(value:Number):void
		{
			_minimum = value;
			invalidate();
		}
		public function get minimum():Number
		{
			if(_autoScale) return getMinValue();
			return _minimum;
		}

		/**
		 * Sets/gets whether the graph will automatically set its own max and min values based on the data values.
		 */
		public function set autoScale(value:Boolean):void
		{
			_autoScale = value;
			invalidate();
		}
		public function get autoScale():Boolean
		{
			return _autoScale;
		}

		/**
		 * Sets/gets whether or not labels for max and min graph values will be shown.
		 * Note: these labels will be to the left of the x position of the chart. Chart position may need adjusting.
		 */
		public function set showScaleLabels(value:Boolean):void
		{
			_showScaleLabels = value;
			if(_showScaleLabels )
			{
				addChild(_maxLabel);
				addChild(_minLabel);
			}
			else
			{
				if(contains(_maxLabel)) removeChild(_maxLabel);
				if(contains(_minLabel)) removeChild(_minLabel);
			}
		}
		public function get showScaleLabels():Boolean
		{
			return _showScaleLabels;
		}

		/**
		 * Sets/gets the amount of decimal places shown in the scale labels.
		 */
		public function set labelPrecision(value:int):void
		{
			_labelPrecision = value;
			invalidate();
		}
		public function get labelPrecision():int
		{
			return _labelPrecision;
		}

		/**
		 * Sets / gets the size of the grid.
		 */
		public function set gridSize(value:int):void
		{
			_panel.gridSize = value;
			invalidate();
		}
		public function get gridSize():int
		{
			return _panel.gridSize;
		}
		
		/**
		 * Sets / gets whether or not the grid will be shown.
		 */
		public function set showGrid(value:Boolean):void
		{
			_panel.showGrid = value;
			invalidate();
		}
		public function get showGrid():Boolean
		{
			return _panel.showGrid;
		}
		
		/**
		 * Sets / gets the color of the grid lines.
		 */
		public function set gridColor(value:uint):void
		{
			_panel.gridColor = value;
			invalidate();
		}
		public function get gridColor():uint
		{
			return _panel.gridColor;
		}
		

	}
}