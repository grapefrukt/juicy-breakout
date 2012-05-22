/**
 * RotarySelector.as
 * Keith Peters
 * version 0.9.10
 * 
 * A rotary selector component for choosing among different values.
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
	
	[Event(name="change", type="flash.events.Event")]
	public class RotarySelector extends Component
	{
		public static const ALPHABETIC:String = "alphabetic";
		public static const NUMERIC:String = "numeric";
		public static const NONE:String = "none";
		public static const ROMAN:String = "roman";
		
		
		protected var _label:Label;
		protected var _labelText:String = "";
		protected var _knob:Sprite;
		protected var _numChoices:int = 2;
		protected var _choice:Number = 0;
		protected var _labels:Sprite;
		protected var _labelMode:String = ALPHABETIC;
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this CheckBox.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param label String containing the label for this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function RotarySelector(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0, label:String = "", defaultHandler:Function = null)
		{
			_labelText = label;
			super(parent, xpos, ypos);
			if(defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			setSize(60, 60);
		}
		
		/**
		 * Creates the children for this component
		 */
		override protected function addChildren():void
		{
			_knob = new Sprite();
			_knob.buttonMode = true;
			_knob.useHandCursor = true;
			addChild(_knob);
			
			_label = new Label();
			_label.autoSize = true;
			addChild(_label);
			
			_labels = new Sprite();
			addChild(_labels);
			
			_knob.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		/**
		 * Decrements the index of the current choice.
		 */
		protected function decrement():void
		{
			if(_choice > 0)
			{
				_choice--;
				draw();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * Increments the index of the current choice.
		 */
		protected function increment():void
		{
			if(_choice < _numChoices - 1)
			{
				_choice++;
				draw();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * Removes old labels.
		 */
		protected function resetLabels():void
		{
			while(_labels.numChildren > 0)
			{
				_labels.removeChildAt(0);
			}
			_labels.x = _width / 2 - 5;
			_labels.y = _height / 2 - 10;
		}
		
		/**
		 * Draw the knob at the specified radius.
		 * @param radius The radius with which said knob will be drawn.
		 */
		protected function drawKnob(radius:Number):void
		{
			_knob.graphics.clear();
			_knob.graphics.beginFill(Style.BACKGROUND);
			_knob.graphics.drawCircle(0, 0, radius);
			_knob.graphics.endFill();
			
			_knob.graphics.beginFill(Style.BUTTON_FACE);
			_knob.graphics.drawCircle(0, 0, radius - 2);
			
			_knob.x = _width / 2;
			_knob.y = _height / 2;
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
			
			var radius:Number = Math.min(_width, _height) / 2;
			drawKnob(radius);
			resetLabels();
			
			var arc:Number = Math.PI * 1.5 / _numChoices; // the angle between each choice
			var start:Number = - Math.PI / 2 - arc * (_numChoices - 1) / 2; // the starting angle for choice 0
			
			graphics.clear();
			graphics.lineStyle(4, Style.BACKGROUND, .5);
			for(var i:int = 0; i < _numChoices; i++)
			{
				var angle:Number = start + arc * i;
				var sin:Number = Math.sin(angle);
				var cos:Number = Math.cos(angle);
				
				graphics.moveTo(_knob.x, _knob.y);
				graphics.lineTo(_knob.x + cos * (radius + 2), _knob.y + sin * (radius + 2));
				
				var lab:Label = new Label(_labels, cos * (radius + 10), sin * (radius + 10));
				lab.mouseEnabled = true;
				lab.buttonMode = true;
				lab.useHandCursor = true;
				lab.addEventListener(MouseEvent.CLICK, onLabelClick);
				if(_labelMode == ALPHABETIC)
				{
					lab.text = String.fromCharCode(65 + i);
				}
				else if(_labelMode == NUMERIC)
				{
					lab.text = (i + 1).toString();
				}
				else if(_labelMode == ROMAN)
				{
					var chars:Array = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"];
					lab.text = chars[i];
				}
				if(i != _choice)
				{
					lab.alpha = 0.5;
				}
			}
			
			angle = start + arc * _choice;
			graphics.lineStyle(4, Style.LABEL_TEXT);
			graphics.moveTo(_knob.x, _knob.y);
			graphics.lineTo(_knob.x + Math.cos(angle) * (radius + 2), _knob.y + Math.sin(angle) * (radius + 2));
			
			
			_label.text = _labelText;
			_label.draw();
			_label.x = _width / 2 - _label.width / 2;
			_label.y = _height + 2;
		}
		
		
		
		///////////////////////////////////
		// event handler
		///////////////////////////////////
		
		/**
		 * Internal click handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onClick(event:MouseEvent):void
		{
			if(mouseX < _width / 2)
			{
				decrement();
			}
			else 
			{
				increment();
			}
		}
		
		protected function onLabelClick(event:Event):void
		{
			var lab:Label = event.target as Label;
			choice = _labels.getChildIndex(lab);
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the number of available choices (maximum of 10).
		 */
		public function set numChoices(value:uint):void
		{
			_numChoices = Math.min(value, 10);
			draw();
		}
		public function get numChoices():uint
		{
			return _numChoices;
		}
		
		/**
		 * Gets / sets the current choice, keeping it in range of 0 to numChoices - 1.
		 */
		public function set choice(value:uint):void
		{
			_choice = Math.max(0, Math.min(_numChoices - 1, value));
			draw();
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function get choice():uint
		{
			return _choice;
		}
		
		/**
		 * Specifies what will be used as labels for each choice. Valid values are "alphabetic", "numeric", and "none".
		 */
		public function set labelMode(value:String):void
		{
			_labelMode = value;
			draw();
		}
		public function get labelMode():String
		{
			return _labelMode;
		}
	}
}