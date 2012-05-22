/**
 * PieChart.as
 * Keith Peters
 * version 0.9.10
 * 
 * A chart component for graphing an array of numeric data as a pie chart.
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
	import com.bit101.components.Label;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * Note: the data parameter of the PieChart, like the other charts, is an array.
	 * It can be a simple array of Numbers where each number represents one slice of the pie.
	 * It can also be an array of objects.
	 * If objects are used, each object represents one slice of the pie and can contain three properties:
	 * - value: The numeric value to chart.
	 * - label: The label to display next to the slice.
	 * - color: The color to make the slice.
	 */
	public class PieChart extends Chart
	{
		protected var _sprite:Sprite;
		protected var _beginningAngle:Number = 0;
		protected var _colors:Array = [
			0xff9999, 0xffff99, 0x99ff99, 0x99ffff, 0x9999ff, 0xff99ff,
			0xffcccc, 0xffffcc, 0xccffcc, 0xccffff, 0xccccff, 0xffccff,
			0xff6666, 0xffff66, 0x99ff66, 0x66ffff, 0x6666ff, 0xff66ff,
			0xffffff
		];
		
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Label.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param data The array of numeric values or objects to graph.
		 */
		public function PieChart(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Array=null)
		{
			super(parent, xpos, ypos, data);
		}
		
		/**
		 * Initializes the component.
		 */
		protected override function init() : void
		{
			super.init();
			setSize(160, 120);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren():void
		{
			super.addChildren();
			_sprite = new Sprite();
			_panel.content.addChild(_sprite);
		}
		
		/**
		 * Graphs the numeric data in the chart.
		 */
		protected override function drawChart() : void
		{
			var radius:Number = Math.min(width - 40, height - 40) / 2;
			_sprite.x = width / 2;
			_sprite.y = height / 2;
			_sprite.graphics.clear();
			_sprite.graphics.lineStyle(0, 0x666666, 1);
			while(_sprite.numChildren > 0) _sprite.removeChildAt(0);
			
			var total:Number = getDataTotal();			
			var startAngle:Number = _beginningAngle * Math.PI / 180;
			for(var i:int = 0; i < _data.length; i++)
			{
				var percent:Number = getValueForData(i) / total;
				var endAngle:Number = startAngle + Math.PI * 2 * percent;
				drawArc(startAngle, endAngle, radius, getColorForData(i));
				makeLabel((startAngle + endAngle) * 0.5, radius + 10, getLabelForData(i));
				startAngle = endAngle;
			}
		}
		
		/**
		 * Creates and positions a single label.
		 * @property angle The angle in degrees to position this label.
		 * @property radius The distance from the center to position this label.
		 * @property text The text of the label.
		 */ 
		protected function makeLabel(angle:Number, radius:Number, text:String):void
		{
			var label:Label = new Label(_sprite, 0, 0, text);
			label.x = Math.cos(angle) * radius;
			label.y = Math.sin(angle) * radius - label.height / 2;
			if(label.x < 0)
			{
				label.x -= label.width;
			}
		}
		
		/**
		 * Draws one slice of the pie.
		 * @property startAngle The beginning angle of the arc.
		 * @property endAngle The ending angle of the arc.
		 * @property radius The radius of the arc.
		 * @property color The color to draw the arc.
		 */
		protected function drawArc(startAngle:Number, endAngle:Number, radius:Number, color:uint):void
		{
			_sprite.graphics.beginFill(color);
			_sprite.graphics.moveTo(0, 0);
			for(var i:Number = startAngle; i < endAngle; i += .01)
			{
				_sprite.graphics.lineTo(Math.cos(i) * radius, Math.sin(i) * radius);
			}
			_sprite.graphics.lineTo(Math.cos(endAngle) * radius, Math.sin(endAngle) * radius);
			_sprite.graphics.lineTo(0, 0);
			_sprite.graphics.endFill();
		}
		
		/**
		 * Determines what label to use for the specified data.
		 * @property index The index of the data to get the label for.
		 */
		protected function getLabelForData(index:int):String
		{
			if(!(_data[index] is Number) && _data[index].label != null)
			{
				return _data[index].label;
			}
			var value:Number = Math.round(getValueForData(index) * Math.pow(10, _labelPrecision)) / Math.pow(10, _labelPrecision);
			return value.toString();
		}
		
		/**
		 * Determines what color to use for the specified data.
		 * @property index The index of the data to get the color for.
		 */
		protected function getColorForData(index:int):uint
		{
			if((!_data[index] is Number) && _data[index].color != null)
			{
				return _data[index].color;
			}
			if(index < _colors.length)
			{
				return _colors[index];
			}
			return Math.random() * 0xffffff;
		}
		
		/**
		 * Determines what value to use for the specified data.
		 * @property index The index of the data to get the value for.
		 */
		protected function getValueForData(index:int):Number
		{
			if(_data[index] is Number)
			{
				return _data[index];
			}
			if(_data[index].value != null)
			{
				return _data[index].value;
			}
			return NaN;
		}
		
		/**
		 * Gets the sum of all the data values.
		 */
		protected function getDataTotal():Number
		{
			var total:Number = 0;
			for(var i:int = 0; i < _data.length; i++)
			{
				total += getValueForData(i);
			}
			return total;
		}

		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the default array of colors to use for each arc.
		 */
		public function set colors(value:Array):void
		{
			_colors = value;
			invalidate();
		}
		public function get colors():Array
		{
			return _colors;
		}

		/**
		 * Sets/gets the angle at which to start the first slice.
		 */
		public function set beginningAngle(value:Number):void
		{
			_beginningAngle = value;
			invalidate();
		}
		public function get beginningAngle():Number
		{
			return _beginningAngle;
		}


	}
}