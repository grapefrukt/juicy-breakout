/**
 * BarChart.as
 * Keith Peters
 * version 0.9.10
 * 
 * A chart component for graphing an array of numeric data as a bar graph.
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
	import flash.display.DisplayObjectContainer;
	
	public class BarChart extends Chart
	{
		protected var _spacing:Number = 2;
		protected var _barColor:uint = 0x999999;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Label.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param data The array of numeric values to graph.
		 */
		public function BarChart(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Array=null)
		{
			super(parent, xpos, ypos, data);
		}
		
		/**
		 * Graphs the numeric data in the chart.
		 */
		protected override function drawChart():void
		{
			var border:Number = 2;
			var totalSpace:Number = _spacing * _data.length;
			var barWidth:Number = (_width - border - totalSpace) / _data.length;
			var chartHeight:Number = _height - border;
			_chartHolder.x = 0;
			_chartHolder.y = _height;
			var xpos:Number = border;
			var max:Number = getMaxValue();
			var min:Number = getMinValue();
			var scale:Number = chartHeight / (max - min);
			for(var i:int = 0; i < _data.length; i++)
			{
				if(_data[i] != null)
				{
					_chartHolder.graphics.beginFill(_barColor);
					_chartHolder.graphics.drawRect(xpos, 0, barWidth, (_data[i] - min) * -scale);
					_chartHolder.graphics.endFill();
				}
				xpos += barWidth + _spacing;
			}
		}

		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the amount of space shown between each bar. If this is too wide, bars may become invisible.
		 */
		public function set spacing(value:Number):void
		{
			_spacing = value;
			invalidate();
		}
		public function get spacing():Number
		{
			return _spacing;
		}

		/**
		 * Sets/gets the color of the bars.
		 */
		public function set barColor(value:uint):void
		{
			_barColor = value;
			invalidate();
		}
		public function get barColor():uint
		{
			return _barColor;
		}


	}
}