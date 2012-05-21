package com.grapefrukt.games.juicy {
	import com.bit101.components.CheckBox;
	import com.bit101.components.HBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.describeType;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Toggler extends Sprite {
		
		private var _targetClass:Class;
		
		public function Toggler(targetClass:Class, visible:Boolean = false) {
			_targetClass = targetClass;
			this.visible = visible;
			reset();
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		private function reset():void {
			var typeXML:XML = describeType(_targetClass);
			
			var properties:Vector.<Property> = new Vector.<Property>();
			var property:Property;
			var tag:XML
			
			for each (var variable:XML in typeXML.variable) {
				property = new Property;
				
				property.name = variable.@name.toString();
				property.value = _targetClass[variable.@name];
				property.type = variable.@type.toString();
				
				if (property.type == "Number" || property.type == "int") {
					property.min = property.value / 2;
					property.max = property.value * 2;
				}
				
				for each (tag in variable.metadata.(@name == "comment")) property.comment = tag.arg.@value;
				for each (tag in variable.metadata.(@name == "max")) property.max = tag.arg.@value;
				for each (tag in variable.metadata.(@name == "min")) property.min = tag.arg.@value;
				
				properties.push(property);
			}
			
			properties.sort(_sort);
			
			var panel:Window = new Window(this, 10, 10);
			panel.width = 250;
			panel.height = properties.length * 28;
			var container:VBox = new VBox(panel, 10, 10);
			for each (property in properties) {
				var row:HBox = new HBox(container);
				var label:Label = new Label(row, 0, 0, prettify(property.name));
				label.autoSize = false;
				label.width = 120;
				switch(property.type) {
					case "Boolean":
						var checkbox:CheckBox = new CheckBox(row, 0, 0, "", getToggleClosure(property.name));
						checkbox.selected = property.value;
						break;
					case "Number" : 
					case "int" :
						var slider:HSlider = new HSlider(row, 0, 0, getSliderClosure(property.name));
						slider.minimum = property.min;
						slider.maximum = property.max;
						slider.value = property.value;
						break;
				}
				
				
			}
			
		}
		
		private function prettify(name:String):String {
			return name.replace("EFFECT", "").replace(/_/g, " ");
		}
		
		private function getToggleClosure(field:String):Function {
			return function(e:Event):void {
				_targetClass[field] = CheckBox(e.target).selected;
			}
		}
		
		private function getSliderClosure(field:String):Function {
			return function(e:Event):void {
				_targetClass[field] = HSlider(e.target).value;
			}
		}
		
		private function handleAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		private function handleKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == 220) visible = !visible;
		}
		
		private function _sort(p1:Property, p2:Property):Number {
			if (p1.name < p2.name) return -1;
			if (p1.name > p2.name) return 1;
			return 0;
		}
	}

}

class Property {
	public var name:String;
	public var comment:String;
	public var type:String;
	public var value:*;
	public var max:Number;
	public var min:Number;
}