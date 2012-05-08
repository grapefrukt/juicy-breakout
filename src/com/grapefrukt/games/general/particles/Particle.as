package com.grapefrukt.games.general.particles {
	import com.grapefrukt.games.general.particles.events.ParticleEvent;
	import com.gskinner.motion.GTween;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Martin Jonasson
	 */
	public class Particle extends Sprite {
		
		protected var _gtween:GTween;
		protected var _scale:Number = 1;
		
		public function Particle(lifespan:Number = 2) {
			_gtween = new GTween(this, lifespan);
			_gtween.onComplete = die;
		}
		
		public function reset():void {
			_gtween.end();
			_gtween.position = -_gtween.delay;
		}
		
		public function init(xPos:Number, yPos:Number, vectorX:Number = 0, vectorY:Number = 0):void {
			x = xPos;
			y = yPos;
			
			_gtween.proxy.x = xPos + vectorX;
			_gtween.proxy.y = yPos + vectorY;
		}
		
		public function die(gt:GTween = null):void {
			dispatchEvent(new ParticleEvent(ParticleEvent.DIE));
		}
		
		public function get scale():Number { 
			return _scale;
		}
		
		public function set scale(value:Number):void {
			_scale = value;
			
			if (_scale < .5) {
				scaleX = _scale * 2;
				scaleY = _scale * 2;
			} else {
				scaleX = 2 - _scale * 2;
				scaleY = 2 - _scale * 2;
			}
			
		}
		
	}

}