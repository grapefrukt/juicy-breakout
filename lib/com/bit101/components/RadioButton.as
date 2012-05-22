/**
 * RadioButton.as
 * Keith Peters
 * version 0.9.10
 * 
 * A basic radio button component, meant to be used in groups, where only one button in the group can be selected.
 * Currently only one group can be created.
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
	import flash.events.MouseEvent;
	
	public class RadioButton extends Component
	{
		protected var _back:Sprite;
		protected var _button:Sprite;
		protected var _selected:Boolean = false;
		protected var _label:Label;
		protected var _labelText:String = "";
		protected var _groupName:String = "defaultRadioGroup";
		
		protected static var buttons:Array;
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this RadioButton.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param label The string to use for the initial label of this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (click in this case).
		 */
		public function RadioButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0, label:String = "", checked:Boolean = false, defaultHandler:Function = null)
		{
			RadioButton.addButton(this);
			_selected = checked;
			_labelText = label;
			super(parent, xpos, ypos);
			if(defaultHandler != null)
			{
				addEventListener(MouseEvent.CLICK, defaultHandler);
			}
		}
		
		/**
		 * Static method to add the newly created RadioButton to the list of buttons in the group.
		 * @param rb The RadioButton to add.
		 */
		protected static function addButton(rb:RadioButton):void
		{
			if(buttons == null)
			{
				buttons = new Array();
			}
			buttons.push(rb);
		}
		
		/**
		 * Unselects all RadioButtons in the group, except the one passed.
		 * This could use some rethinking or better naming.
		 * @param rb The RadioButton to remain selected.
		 */
		protected static function clear(rb:RadioButton):void
		{
			for(var i:uint = 0; i < buttons.length; i++)
			{
				if(buttons[i] != rb && buttons[i].groupName == rb.groupName)
				{
					buttons[i].selected = false;
				}
			}
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			
			buttonMode = true;
			useHandCursor = true;
			
			addEventListener(MouseEvent.CLICK, onClick, false, 1);
			selected = _selected;
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			addChild(_back);
			
			_button = new Sprite();
			_button.filters = [getShadow(1)];
			_button.visible = false;
			addChild(_button);
			
			_label = new Label(this, 0, 0, _labelText);
			draw();
			
			mouseChildren = false;
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
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawCircle(5, 5, 5);
			_back.graphics.endFill();
			
			_button.graphics.clear();
			_button.graphics.beginFill(Style.BUTTON_FACE);
			_button.graphics.drawCircle(5, 5, 3);
			
			_label.x = 12;
			_label.y = (10 - _label.height) / 2;
			_label.text = _labelText;
			_label.draw();
			_width = _label.width + 12;
			_height = 10;
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal click handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onClick(event:MouseEvent):void
		{
			selected = true;
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the selected state of this CheckBox.
		 */
		public function set selected(s:Boolean):void
		{
			_selected = s;
			_button.visible = _selected;
			if(_selected)
			{
				RadioButton.clear(this);
			}
		}
		public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * Sets / gets the label text shown on this CheckBox.
		 */
		public function set label(str:String):void
		{
			_labelText = str;
			invalidate();
		}
		public function get label():String
		{
			return _labelText;
		}

		/**
		 * Sets / gets the group name, which allows groups of RadioButtons to function seperately.
		 */
		public function get groupName():String
		{
			return _groupName;
		}

		public function set groupName(value:String):void
		{
			_groupName = value;
		}

		
	}
}