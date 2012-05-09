package com.grapefrukt.games.juicy.events {
	import com.grapefrukt.games.juicy.gameobjects.Ball;
	import com.grapefrukt.games.juicy.gameobjects.Block;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class JuicyEvent extends Event {
		
		public static const BLOCK_DESTROYED:String = "juicyevent_block_destroyed";
		public static const BALL_COLLIDE:String = "juicyevent_ball_collide";
		
		private var _ball:Ball;
		private var _block:Block;
		
		public function JuicyEvent(type:String, ball:Ball = null, block:Block = null) { 
			super(type);
			_ball = ball;
			_block = block;
		} 
		
		public override function clone():Event { 
			return new JuicyEvent(type);
		} 
		
		public override function toString():String { 
			return formatToString("JuicyEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get ball():Ball {
			return _ball;
		}
		
		public function get block():Block {
			return _block;
		}
		
	}
	
}