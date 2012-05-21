package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.effects.Rainbow;
	import com.grapefrukt.games.juicy.events.JuicyEvent;
	import com.grapefrukt.games.juicy.Settings;
	import com.grapefrukt.math.MathUtil;
	import flash.display.Shape;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Ball extends GameObject {
		
		private static const SIZE:Number = 15;
		
		private var _trail:Rainbow;
		private var _gfx:Shape;
		
		private var _ball_shakiness:Number;
		private var _ball_shakiness_vel:Number;
		
		public var exX:Number;
		public var exY:Number;
		
		public function Ball(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			
			_trail = new Rainbow();
			addChild(_trail);
			
			_gfx = new Shape;
			_gfx.graphics.beginFill(Settings.COLOR_BALL);
			_gfx.graphics.drawRect( -SIZE / 2, -SIZE / 2, SIZE, SIZE);
			// _gfx.graphics.drawCircle( 0, 0, SIZE / 2 );
			addChild(_gfx);
			
			var v:Point = Point.polar(5, Math.random() * Math.PI * 2);
			velocityX = v.x;
			velocityY = v.y;
			
			_ball_shakiness = 0;
			_ball_shakiness_vel = 0;
		}
		
		override public function update(timeDelta:Number = 1):void {
			exX = x;
			exY = y;
			super.update(timeDelta);
			
			if (Settings.EFFECT_BALL_ROTATE) {
				_gfx.rotation = Math.atan2(velocityY, velocityX) / Math.PI * 180;
			} else {
				_gfx.rotation = 0;
			}
			
			if( Math.abs( _ball_shakiness ) > 0 ) {
				_ball_shakiness_vel += -0.25 * _ball_shakiness;
				_ball_shakiness_vel *= 0.90;

				_ball_shakiness += _ball_shakiness_vel; 
			}

			
			if (Settings.EFFECT_BALL_STRETCH) {
				// _gfx.scaleX = 1 + (velocity - Settings.BALL_MIN_VELOCITY) / (Settings.BALL_MAX_VELOCITY - Settings.BALL_MIN_VELOCITY) * .3;
				// _gfx.scaleY = 1 - (velocity - Settings.BALL_MIN_VELOCITY) / (Settings.BALL_MAX_VELOCITY - Settings.BALL_MIN_VELOCITY) * .2;
				
				var relative:Number = 1.0 + ( velocity / (2 * Settings.BALL_MAX_VELOCITY ) );
				relative = MathUtil.clamp( relative, 5.0, 1.0 );
				_gfx.scaleX = 1.0 * relative;
				_gfx.scaleY = 1.0 / relative;
				
				_gfx.scaleX -= _ball_shakiness;
				_gfx.scaleY += _ball_shakiness;
				
				_gfx.scaleX = MathUtil.clamp( _gfx.scaleX, 1.5, 0.5 );
				_gfx.scaleY = MathUtil.clamp( _gfx.scaleY, 3.5, 0.5 );
				
			} else {
				_gfx.scaleX = scaleY = 1;
			}
		}
		
		public function updateTrail():void {
			_trail.addSegment(x, y);
			_trail.redrawSegments(x, y);
		}
		
		public function collide(velocityMultiplierX:Number, velocityMultiplierY:Number, block:Block = null):void {
			velocityX *= velocityMultiplierX;
			velocityY *= velocityMultiplierY;
			dispatchEvent(new JuicyEvent(JuicyEvent.BALL_COLLIDE, this, block));
			_ball_shakiness = 2.5;
		}
		
		public function collideSet( newVelocityX:Number, newVelocityY:Number, block:Block = null ):void {
			velocityX = newVelocityX;
			velocityY = newVelocityY;
			dispatchEvent(new JuicyEvent(JuicyEvent.BALL_COLLIDE, this, block));
			_ball_shakiness = 2.5;
			_ball_shakiness_vel = 0;
		}
		
	}

}