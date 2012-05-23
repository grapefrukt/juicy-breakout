package com.grapefrukt.games.juicy.effects.particles {
	import com.grapefrukt.display.utilities.ColorConverter;
	import com.grapefrukt.games.general.particles.Particle;
	import com.gskinner.geom.ColorMatrix;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.easing.Bounce;
	import com.gskinner.motion.easing.Exponential;
	import com.gskinner.motion.GTween;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class ConfettiParticle extends Particle {
		
		private var _gfx:ConfettiParticleGfx;
		private var _vectorX:Number;
		private var _vectorY:Number;
		
		public function ConfettiParticle(lifespan:Number=2) {
			super(lifespan);
			_gfx = new ConfettiParticleGfx;
			addChild(_gfx);
			_gfx.rotation = Math.random() * 360;
			
			_gtween.onChange = update;
			
			var colors:Array = ColorConverter.HSBtoRGB(Math.random(), 1, 1);
			_gfx.transform.colorTransform = new ColorTransform(colors[0] / 255, colors[1] / 255, colors[2] / 255);
		}
		
		override public function init(xPos:Number, yPos:Number, vectorX:Number = 0, vectorY:Number = 0):void {
			_vectorY = vectorY;
			_vectorX = vectorX;
			x = xPos;
			y = yPos;
			rotation = 0;
			scale = .8;
			alpha = 1;
			
			_gtween.delay = Math.random() * .3;
			_gtween.proxy.scaleX = _gtween.proxy.scaleY = .01;
			
			_gtween.proxy.rotation = Math.random() * 360;
			//_gtween.proxy.alpha = 0;
			
			_gfx.gotoAndPlay(int(Math.random() * _gfx.totalFrames));
		}
		
		private function update(gt:GTween):void {
			x += _vectorX / 100;
			y += _vectorY / 100;
			
			var timeDelta:Number = 1;
			_vectorY += 10 * timeDelta;
			_vectorX -= _vectorX * .05 * timeDelta;
			_vectorY -= _vectorY * .05 * timeDelta;
		}
		
	}

}