/**
 * LineChart.as
 * Keith Peters
 * version 0.9.10
 * 
 * A chart component for graphing an array of numeric data as a line graph.
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
	
	public class LineChart extends Chart
	{
		protected var _lineWidth:Number = 1;
		protected var _lineColor:uint = 0x999999;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Label.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param data The array of numeric values to graph.
		 */
		public function LineChart(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Array=null)
		{
			super(parent, xpos, ypos, data);
		}
		
		/**
		 * Graphs the numeric data in the chart.
		 */
		protected override function drawChart():void
		{
			var border:Number = 2;
			var lineWidth:Number = (_width - border) / (_data.length - 1);
			var chartHeight:Number = _height - border;
			_chartHolder.x = 0;
			_chartHolder.y = _height;
			var xpos:Number = border;
			var max:Number = getMaxValue();
			var min:Number = getMinValue();
			var scale:Number = chartHeight / (max - min);
			_chartHolder.graphics.lineStyle(_lineWidth, _lineColor);
			_chartHolder.graphics.moveTo(xpos, (_data[0] - min) * -scale);
			xpos += lineWidth;
			for(var i:int = 1; i < _data.length; i++)
			{
				if(_data[i] != null)
				{
					_chartHolder.graphics.lineTo(xpos, (_data[i] - min) * -scale);
				}
				xpos += lineWidth;
			}
		}

		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		/**
		 * Sets/gets the width of the line in the graph.
		 */
		public function set lineWidth(value:Number):void
		{
			_lineWidth = value;
			invalidate();
		}
		public function get lineWidth():Number
		{
			return _lineWidth;
		}

		/**
		 * Sets/gets the color of the line in the graph.
		 */
		public function set lineColor(value:uint):void
		{
			_lineColor = value;
			invalidate();
		}
		public function get lineColor():uint
		{
			return _lineColor;
		}


	}
}