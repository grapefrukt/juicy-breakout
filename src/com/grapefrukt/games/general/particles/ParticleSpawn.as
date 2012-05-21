package com.grapefrukt.games.general.particles {
	import com.grapefrukt.games.general.collections.GameObjectCollection;
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import flash.geom.Point;
	
	/**
	* ...
	* @author Martin Jonasson
	*/
	public class ParticleSpawn {
		
		/**
		 * Creates a burst of particles
		 * @param	x 				The x position
		 * @param	y 				The y position
		 * @param	count			The number of particles to create
		 * @param	spread			The spread in degrees to create them at
		 * @param	baseAngle		The base angle to burst in
		 * @param	speed			A multiplier for the particles speed
		 * @param	particleClass	The class of particles
		 * @param	particleRules	The ruleset for the particles
		 * @param	collection		The ParticleCollection to add them to
		 * @param	vector			A directional vector that will be added to the particles own vector
		 */
		public static function burst(spawnX:Number, spawnY:Number, count:uint, spread:Number, baseAngle:Number, speed:Number, speedVariance:Number, pool:ParticlePool):void {
			var speedRnd:Number;
			var angleVector:Point = new Point();
			var spreadRnd:Number = 0;
			
			for(var i:Number = 0; i < count; i++){
				var particle:Particle = pool.add();
				
				particle.x = spawnX; 
				particle.y = spawnY;
				
				speedRnd = Math.random() * speedVariance - speedVariance / 2
				spreadRnd = Math.random() * spread - spread / 2;
				
				angleVector.x = Math.sin((-baseAngle + spreadRnd) / 180 * Math.PI) * speed * (1 + speedRnd);
				angleVector.y = Math.cos((-baseAngle + spreadRnd) / 180 * Math.PI) * speed * (1 + speedRnd);
				
				particle.init(spawnX, spawnY, angleVector.x, angleVector.y);
			}
		}
		
		public static function explode(spawnX:Number, spawnY:Number, count:uint, distanceMultiplier:Number, pool:ParticlePool, randomRange:Number = 2, vector:Point = null, spawnAreaSize:Number = 0):void{
			if (vector == null) vector = new Point(0, 0);
			for(var i:Number = 0; i < count; i++){
				var particle:Particle = pool.add();
				particle.init(	spawnX + (Math.random() - .5) * spawnAreaSize, 
								spawnY + (Math.random() - .5) * spawnAreaSize, 
								(vector.x + (Math.random() - .5) * randomRange) * distanceMultiplier,  
								(vector.y + (Math.random() - .5) * randomRange) * distanceMultiplier);
			}
		}
		
		public static function explode2(position:Point, pool:ParticlePool, count:uint, randomRange:Point = null, vector:Point = null, spawnAreaSize:Number = 0, distanceMultiplier:Number = 1):void{
			if (randomRange == null) randomRange = new Point(0, 0);
			if (vector == null) vector = new Point(0, 0);
			for(var i:Number = 0; i < count; i++){
				var particle:Particle = pool.add();
				particle.init(	position.x + (Math.random() - .5) * spawnAreaSize, 
								position.y + (Math.random() - .5) * spawnAreaSize, 
								(vector.x  + (Math.random() - .5) * randomRange.x) * distanceMultiplier,  
								(vector.y  + (Math.random() - .5) * randomRange.y) * distanceMultiplier);
			}
		}
		
	}
	
}