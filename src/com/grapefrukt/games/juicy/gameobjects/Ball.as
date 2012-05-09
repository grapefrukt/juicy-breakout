package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.events.JuicyEvent;
	import com.grapefrukt.games.juicy.Settings;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Ball extends GameObject {
		
		private static const SIZE:Number = 20;
		private var _bounce:Number = 0;
		private var _bounceVelocity:Number = 0;
		
		public function Ball(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			
			graphics.beginFill(0x4ecdc4);
			graphics.drawRect(-SIZE/2, -SIZE/2, SIZE, SIZE);
			
			var v:Point = Point.polar(5, Math.random() * Math.PI * 2);
			velocityX = v.x;
			velocityY = v.y;
		}
		
		override public function update(timeDelta:Number = 1):void {
			super.update(timeDelta);
			if (Settings.EFFECT_STRETCH_BALL) {
				rotation = Math.atan2(velocityY, velocityX) / Math.PI * 180;
				_bounceVelocity += ( 0 - _bounce) * .05 * timeDelta;
				_bounceVelocity -= _bounceVelocity * .2 * timeDelta; // drag
				_bounce += _bounceVelocity * timeDelta;
				
				scaleX = 1 + _bounce;
				scaleY = 1 - scaleX * .25;
			} else {
				scaleX = scaleY = 1;
			}
		}
		
		public function collide(velocityMultiplierX:Number, velocityMultiplierY:Number, block:Block = null):void {
			_bounce = -.25;
			_bounceVelocity = 0;
			
			velocityX *= velocityMultiplierX;
			velocityY *= velocityMultiplierY;
			dispatchEvent(new JuicyEvent(JuicyEvent.BALL_COLLIDE, this, block));
		}
		
	}

}