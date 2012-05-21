package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.effects.Rainbow;
	import com.grapefrukt.games.juicy.events.JuicyEvent;
	import com.grapefrukt.games.juicy.Settings;
	import com.grapefrukt.math.MathUtil;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.GTween;
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
		private var _ball_rotation:Number;
		
		private var _ball_color:uint;
		
		public var exX:Number;
		public var exY:Number;
		
		public function Ball(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			
			_trail = new Rainbow();
			addChild(_trail);
			
			_gfx = new Shape;
			drawBall();
			addChild(_gfx);
			
			var v:Point = Point.polar(5, Math.random() * Math.PI * 2);
			velocityX = v.x;
			velocityY = v.y;
			
			_ball_shakiness = 0;
			_ball_shakiness_vel = 0;
			_ball_rotation = 0;
		}
		
		private function drawBall():void {
			_gfx.graphics.clear();
			_gfx.graphics.beginFill(Settings.COLOR_BALL);
			_gfx.graphics.drawRect( -SIZE / 2, -SIZE / 2, SIZE, SIZE);
			// _gfx.graphics.drawCircle( 0, 0, SIZE / 2 );
		}
		
		override public function update(timeDelta:Number = 1):void {
			exX = x;
			exY = y;
			super.update(timeDelta);
			
			if (Settings.EFFECT_BALL_ROTATE) {
				var target_rotation:Number = Math.atan2(velocityY, velocityX) / Math.PI * 180;
				_ball_rotation += ( target_rotation - _ball_rotation ) * 0.5;
				// _ball_rotation = target_rotation;
				_gfx.rotation = _ball_rotation;
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
				relative = MathUtil.clamp( relative, 2.5, 1.0 );
				_gfx.scaleX = 1.0 * relative;
				_gfx.scaleY = 1.0 / relative;
				
				_gfx.scaleX -= _ball_shakiness;
				_gfx.scaleY += _ball_shakiness;
				
				// _gfx.scaleX = MathUtil.clamp( _gfx.scaleX, 1.5, 0.5 );
				// _gfx.scaleY = MathUtil.clamp( _gfx.scaleY, 2.5, 0.5 );
				_gfx.scaleX = MathUtil.clamp( _gfx.scaleX, 1.35, 0.85 );
				_gfx.scaleY = MathUtil.clamp( _gfx.scaleY, 1.35, 0.85 );
				
			} else {
				_gfx.scaleX = scaleY = 1;
			}
		}
		
		public function updateTrail():void {
			_trail.addSegment(x, y);
			_trail.redrawSegments(x, y);
		}
		
		private function doCollisionEffects( block:Block = null ):void {
			dispatchEvent(new JuicyEvent(JuicyEvent.BALL_COLLIDE, this, block));
			_ball_shakiness = 0.1;
			_ball_shakiness_vel = 2.5;
			
			
			new GTween( this, 0.01, { brightness:255 } );
			new GTween( this, 0.7, { brightness:0 }, { ease:Back.easeOut } );
			
		}
		
		public function collide(velocityMultiplierX:Number, velocityMultiplierY:Number, block:Block = null):void {
			velocityX *= velocityMultiplierX;
			velocityY *= velocityMultiplierY;
			doCollisionEffects(block);
		}
		
		public function collideSet( newVelocityX:Number, newVelocityY:Number, block:Block = null ):void {
			velocityX = newVelocityX;
			velocityY = newVelocityY;
			doCollisionEffects(block);
		}
		
	}

}