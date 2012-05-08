package com.grapefrukt.games.general.events {
	import com.grapefrukt.games.general.collections.GameObjectCollection;
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Martin Jonasson
	 */
	public class GameObjectEvent extends Event {
		
		public static const REMOVE					:String = "gameobjectevent_remove";
		public static const DETACH					:String = "gameobjectevent_detach";
		
		private var _collection:GameObjectCollection;
		private var _game_object:GameObject;
		
		public function GameObjectEvent(type:String, gameObject:GameObject, collection:GameObjectCollection) { 
			super(type, bubbles, cancelable);
			_game_object = gameObject;
			_collection = collection;
		}
		
		public override function clone():Event { 
			return new GameObjectEvent(type, gameObject, collection);
		} 
		
		public override function toString():String { 
			return formatToString("GameObjectEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get gameObject():GameObject 
		{
			return _game_object;
		}
		
		public function get collection():GameObjectCollection 
		{
			return _collection;
		}
		
	}
	
}