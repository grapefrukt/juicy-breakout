package com.grapefrukt.games.juicy {
	import com.bit101.components.Accordion;
	import com.bit101.components.CheckBox;
	import com.bit101.components.HBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
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
		private var _properties:Vector.<Property>;
		
		public function Toggler(targetClass:Class, visible:Boolean = false) {
			_targetClass = targetClass;
			this.visible = visible;
			reset();
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		private function reset():void {
			var typeXML:XML = describeType(_targetClass);
			
			_properties = new Vector.<Property>();
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
				
				_properties.push(property);
			}
			
			_properties.sort(_sort);
			
			while (numChildren) removeChildAt(0);
			
			var settingWindow:Window = new Window(this, 10, 10);
			settingWindow.title = "JUICEATRON 5000 X";
			settingWindow.width = 250;
			settingWindow.height = Settings.STAGE_H - 50;
			
			var accordion:Accordion = new Accordion(settingWindow);
			var window:Window;
			
			for each (property in _properties) {
				var groupName:String = getGroupName(property.name);
				//trace(window ? window.title : "null", groupName);
				if (!window || window.title != groupName) {
					if (window) {
						window.content.getChildAt(0).height = DisplayObjectContainer(window.content.getChildAt(0)).numChildren * 30;
					}
					
					accordion.addWindowAt(groupName, accordion.numWindows);
					window = accordion.getWindowAt(accordion.numWindows - 1);
					var container:VBox = new VBox(window.content, 10, 10);
				}
				
				var row:HBox = new HBox(DisplayObjectContainer(window.content.getChildAt(0)));
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
			
			accordion.height = Settings.STAGE_H - 50 - 20;
			accordion.width = 250;
			
		}
		
		public function setAll(value:Boolean):void {
			for each (var property:Property in _properties) {
				if (property.type == "Boolean") _targetClass[property.name] = value;
			}
			reset();
		}
		
		private function prettify(name:String):String {
			return name.replace("EFFECT_", "").replace(/_/g, " ");
		}
		
		private function getGroupName(name:String):String {
			name = name.replace("EFFECT_", "");
			return name.replace(/_[A-Z].*/, "");
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