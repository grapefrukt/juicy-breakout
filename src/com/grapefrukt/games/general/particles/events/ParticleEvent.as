package com.grapefrukt.games.general.particles.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Martin Jonasson
	 */
	public class ParticleEvent extends Event {
		
		public static const DIE:String = 'particle_event_die';
		
		public function ParticleEvent(type:String) { 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new ParticleEvent(type);
		} 
		
		public override function toString():String { 
			return formatToString("ParticleEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}