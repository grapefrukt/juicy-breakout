package com.grapefrukt.games.general.particles {
	import com.grapefrukt.games.general.particles.events.ParticleEvent;
	import de.polygonal.core.ObjectPool;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Martin Jonasson
	 */
	public class ParticlePool extends Sprite {
		
		private var _particleclass	:Class;
		private var _pool			:ObjectPool;
		
		public function ParticlePool(particleClass:Class, size:int = 20) {
			_particleclass = particleClass;
			_pool = new ObjectPool(true);
			_pool.allocate(_particleclass, size);
			_pool.initialize("reset", []);
			
			addEventListener(ParticleEvent.DIE, handleParticleDeath, true);
		}
		
		private function handleParticleDeath(e:ParticleEvent):void {
			var p:Particle = e.target as Particle;
			removeChild(p);
			_pool.object = p;
		}
		
		public function add():Particle {
			var p:Particle = _pool.object;
			addChild(p);
			return p;
		}
		
	}

}