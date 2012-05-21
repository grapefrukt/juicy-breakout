package com.grapefrukt.games.juicy.effects.particles {
	import com.grapefrukt.games.general.particles.Particle;
	import com.grapefrukt.games.juicy.Settings;
	import com.gskinner.motion.easing.Quadratic;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class BallImpactParticle extends Particle {
		
		public function BallImpactParticle() {
			super(.3 + Math.random() * .3);
			graphics.beginFill(Settings.COLOR_SPARK);
			graphics.drawCircle(0, 0, 7);
			cacheAsBitmap = true;
			_gtween.ease = Quadratic.easeOut;
		}
		
		override public function init(xPos:Number, yPos:Number, vectorX:Number = 0, vectorY:Number = 0):void {
			super.init(xPos, yPos, vectorX, vectorY);
			scaleX = scaleY = 1;
			_gtween.proxy.scaleX = .1;
			_gtween.proxy.scaleY = .1;
		}
		
	}

}