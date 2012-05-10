package com.grapefrukt.games.juicy {
	import com.bit101.components.CheckBox;
	import com.bit101.components.HBox;
	import com.bit101.components.Panel;
	import com.bit101.components.VBox;
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
			
			for each (var variable:XML in typeXML.variable) {
				property = new Property;
				
				for each (var comment:XML in variable.metadata.(@name == "comment")) {
					property.comment = comment.arg.@value;
				}
				
				property.name = variable.@name.toString();
				property.value = _targetClass[variable.@name];
				
				properties.push(property);
			}
			
			var panel:Panel = new Panel(this, 10, 10);
			panel.width = 200;
			panel.height = 200;
			var container:VBox = new VBox(panel, 10, 10);
			for each (property in properties) {
				//var row:HBox = new HBox(container);
				var checkbox:CheckBox = new CheckBox(container, 0, 0, prettify(property.name), getToggleClosure(property));
				checkbox.selected = property.value;
			}
			
		}
		
		private function getToggleClosure(property:Property):Function {
			return function(e:Event):void {
				_targetClass[property.name] = CheckBox(e.target).selected;
			}
		}
		
		private function prettify(name:String):String {
			return name.replace("EFFECT", "").replace(/_/g, " ");
		}
		
	}

}

class Property {
	public var name:String;
	public var comment:String;
	public var value:*;
}