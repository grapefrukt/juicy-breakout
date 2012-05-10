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
	import flash.utils.describeType;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Toggler extends Sprite {
		
		private var _targetClass:Class;
		
		public function Toggler(targetClass:Class) {
			_targetClass = targetClass;
			reset();
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
			
			var panel:Window = new Window(this, 10, 10);
			panel.width = 250;
			panel.height = 240;
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