/**
 * ColorChooser.as
 * Keith Peters
 * version 0.9.10
 * 
 * A Color Chooser component, allowing textual input, a default gradient, or custom image.
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * popup color choosing code by Rashid Ghassempouri
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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	[Event(name="change", type="flash.events.Event")]
	public class ColorChooser extends Component
	{
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		
		protected var _colors:BitmapData;
		protected var _colorsContainer:Sprite;
		protected var _defaultModelColors:Array=[0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000,0xFFFFFF,0x000000];
		protected var _input:InputText;
		protected var _model:DisplayObject;
		protected var _oldColorChoice:uint = _value;
		protected var _popupAlign:String = BOTTOM;
		protected var _stage:Stage;
		protected var _swatch:Sprite;
		protected var _tmpColorChoice:uint = _value;
		protected var _usePopup:Boolean = false;
		protected var _value:uint = 0xff0000;
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ColorChooser.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param value The initial color value of this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		
		public function ColorChooser(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0, value:uint = 0xff0000, defaultHandler:Function = null)
		{
			_oldColorChoice = _tmpColorChoice = _value = value;
			
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

			_width = 65;
			_height = 15;
			value = _value;
		}
		
		override protected function addChildren():void
		{
			_input = new InputText();
			_input.width = 45;
			_input.restrict = "0123456789ABCDEFabcdef";
			_input.maxChars = 6;
			addChild(_input);
			_input.addEventListener(Event.CHANGE, onChange);
			
			_swatch = new Sprite();
			_swatch.x = 50;
			_swatch.filters = [getShadow(2, true)];
			addChild(_swatch);
			
			_colorsContainer = new Sprite();
			_colorsContainer.addEventListener(Event.ADDED_TO_STAGE, onColorsAddedToStage);
			_colorsContainer.addEventListener(Event.REMOVED_FROM_STAGE, onColorsRemovedFromStage);
			_model = getDefaultModel();
			drawColors(_model);
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
			_swatch.graphics.clear();
			_swatch.graphics.beginFill(_value);
			_swatch.graphics.drawRect(0, 0, 16, 16);
			_swatch.graphics.endFill();
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal change handler.
		 * @param event The Event passed by the system.
		 */
		protected function onChange(event:Event):void
		{
			event.stopImmediatePropagation();
			_value = parseInt("0x" + _input.text, 16);
			_input.text = _input.text.toUpperCase();
			_oldColorChoice = value;
			invalidate();
			dispatchEvent(new Event(Event.CHANGE));
			
		}	
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the color value of this ColorChooser.
		 */
		public function set value(n:uint):void
		{
			var str:String = n.toString(16).toUpperCase();
			while(str.length < 6)
			{
				str = "0" + str;
			}
			_input.text = str;
			_value = parseInt("0x" + _input.text, 16);
			invalidate();
		}
		public function get value():uint
		{
			return _value;
		}
		
		///////////////////////////////////
		// COLOR PICKER MODE SUPPORT
		///////////////////////////////////}
		
		
		public function get model():DisplayObject { return _model; }
		public function set model(value:DisplayObject):void 
		{
			_model = value;
			if (_model!=null) {
				drawColors(_model);
				if (!usePopup) usePopup = true;
			} else {
				_model = getDefaultModel();
				drawColors(_model);
				usePopup = false;
			}
		}
		
		protected function drawColors(d:DisplayObject):void{
			_colors = new BitmapData(d.width, d.height);
			_colors.draw(d);
			while (_colorsContainer.numChildren) _colorsContainer.removeChildAt(0);
			_colorsContainer.addChild(new Bitmap(_colors));
			placeColors();
		}
		
		public function get popupAlign():String { return _popupAlign; }
		public function set popupAlign(value:String):void {
			_popupAlign = value;
			placeColors();
		}
		
		public function get usePopup():Boolean { return _usePopup; }
		public function set usePopup(value:Boolean):void {
			_usePopup = value;
			
			_swatch.buttonMode = true;
			_colorsContainer.buttonMode = true;
			_colorsContainer.addEventListener(MouseEvent.MOUSE_MOVE, browseColorChoice);
			_colorsContainer.addEventListener(MouseEvent.MOUSE_OUT, backToColorChoice);
			_colorsContainer.addEventListener(MouseEvent.CLICK, setColorChoice);
			_swatch.addEventListener(MouseEvent.CLICK, onSwatchClick);
			
			if (!_usePopup) {
				_swatch.buttonMode = false;
				_colorsContainer.buttonMode = false;
				_colorsContainer.removeEventListener(MouseEvent.MOUSE_MOVE, browseColorChoice);
				_colorsContainer.removeEventListener(MouseEvent.MOUSE_OUT, backToColorChoice);
				_colorsContainer.removeEventListener(MouseEvent.CLICK, setColorChoice);
				_swatch.removeEventListener(MouseEvent.CLICK, onSwatchClick);
			}
		}
		
		/**
		 * The color picker mode Handlers 
		 */
		
		protected function onColorsRemovedFromStage(e:Event):void {
			_stage.removeEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		protected function onColorsAddedToStage(e:Event):void {
			_stage = stage;
			_stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		protected function onStageClick(e:MouseEvent):void {
			displayColors();
		}
		 
		
		protected function onSwatchClick(event:MouseEvent):void 
		{
			event.stopImmediatePropagation();
			displayColors();
		}
		
		protected function backToColorChoice(e:MouseEvent):void 
		{
			value = _oldColorChoice;
		}
		
		protected function setColorChoice(e:MouseEvent):void {
			value = _colors.getPixel(_colorsContainer.mouseX, _colorsContainer.mouseY);
			_oldColorChoice = value;
			dispatchEvent(new Event(Event.CHANGE));
			displayColors();
		}
		
		protected function browseColorChoice(e:MouseEvent):void 
		{
			_tmpColorChoice = _colors.getPixel(_colorsContainer.mouseX, _colorsContainer.mouseY);
			value = _tmpColorChoice;
		}

		/**
		 * The color picker mode Display functions
		 */
		
		protected function displayColors():void 
		{
			placeColors();
			if (_colorsContainer.parent) _colorsContainer.parent.removeChild(_colorsContainer);
			else stage.addChild(_colorsContainer);
		}		
		
		protected function placeColors():void{
			var point:Point = new Point(x, y);
			if(parent) point = parent.localToGlobal(point);
			switch (_popupAlign)
			{
				case TOP : 
					_colorsContainer.x = point.x;
					_colorsContainer.y = point.y - _colorsContainer.height - 4;
				break;
				case BOTTOM : 
					_colorsContainer.x = point.x;
					_colorsContainer.y = point.y + 22;
				break;
				default: 
					_colorsContainer.x = point.x;
					_colorsContainer.y = point.y + 22;
				break;
			}
		}
		
		/**
		 * Create the default gradient Model
		 */

		protected function getDefaultModel():Sprite {	
			var w:Number = 100;
			var h:Number = 100;
			var bmd:BitmapData = new BitmapData(w, h);
			
			var g1:Sprite = getGradientSprite(w, h, _defaultModelColors);
			bmd.draw(g1);
					
			var blendmodes:Array = [BlendMode.MULTIPLY,BlendMode.ADD];
			var nb:int = blendmodes.length;
			var g2:Sprite = getGradientSprite(h/nb, w, [0xFFFFFF, 0x000000]);		
			
			for (var i:int = 0; i < nb; i++) {
				var blendmode:String = blendmodes[i];
				var m:Matrix = new Matrix();
				m.rotate(-Math.PI / 2);
				m.translate(0, h / nb * i + h/nb);
				bmd.draw(g2, m, null,blendmode);
			}
			
			var s:Sprite = new Sprite();
			var bm:Bitmap = new Bitmap(bmd);
			s.addChild(bm);
			return(s);
		}
		
		protected function getGradientSprite(w:Number, h:Number, gc:Array):Sprite 
		{
			var gs:Sprite = new Sprite();
			var g:Graphics = gs.graphics;
			var gn:int = gc.length;
			var ga:Array = [];
			var gr:Array = [];
			var gm:Matrix = new Matrix(); gm.createGradientBox(w, h, 0, 0, 0);
			for (var i:int = 0; i < gn; i++) { ga.push(1); gr.push(0x00 + 0xFF / (gn - 1) * i); }
			g.beginGradientFill(GradientType.LINEAR, gc, ga, gr, gm, SpreadMethod.PAD,InterpolationMethod.RGB);
			g.drawRect(0, 0, w, h);
			g.endFill();	
			return(gs);
		}
	}
}