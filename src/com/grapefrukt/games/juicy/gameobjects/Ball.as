package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.effects.Rainbow;
	import com.grapefrukt.games.juicy.events.JuicyEvent;
	import com.grapefrukt.games.juicy.Settings;
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
		
		public function Ball(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			
			_trail = new Rainbow(1);
			addChild(_trail);
			
			_gfx = new Shape;
			_gfx.graphics.beginFill(Settings.COLOR_BALL);
			_gfx.graphics.drawRect( -SIZE / 2, -SIZE / 2, SIZE, SIZE);
			addChild(_gfx);
			
			var v:Point = Point.polar(5, Math.random() * Math.PI * 2);
			velocityX = v.x;
			velocityY = v.y;
		}
		
		override public function update(timeDelta:Number = 1):void {
			super.update(timeDelta);
			if (Settings.EFFECT_BALL_STRETCH) {
				_gfx.rotation = Math.atan2(velocityY, velocityX) / Math.PI * 180;
				_gfx.scaleX = 1 + (velocity - Settings.BALL_MIN_VELOCITY) / (Settings.BALL_MAX_VELOCITY - Settings.BALL_MIN_VELOCITY) * .3;
				_gfx.scaleY = 1 - (velocity - Settings.BALL_MIN_VELOCITY) / (Settings.BALL_MAX_VELOCITY - Settings.BALL_MIN_VELOCITY) * .2;
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
		}
		
	}

}