package com.grapefrukt.games.juicy {
	import flash.display.DisplayObject;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Shaker {
		
		private var _velocity:Point;
		private var _position:Point;
		private var _target:DisplayObject;
		private var _drag:Number = .1;
		private var _elasticity:Number = .1;
		
		public function Shaker(target:DisplayObject) {
			_target = target;
			_velocity = new Point();
			_position = new Point();
		}
		
		public function shake(powerX:Number, powerY:Number):void {
			_velocity.x += powerX;
			_velocity.y += powerY;
		}
		
		public function shakeRandom(power:Number):void {
			_velocity = Point.polar(power, Math.random() * Math.PI * 2);
		}
		
		public function update(delta:Number):void {
			_velocity.x -= _velocity.x * _drag * delta;
			_velocity.y -= _velocity.y * _drag * delta;
			
			_velocity.x -= (_position.x) * _elasticity * delta;
			_velocity.y -= (_position.y) * _elasticity * delta;
			
			_position.x += (_velocity.x) * delta;
			_position.y += (_velocity.y) * delta;
			
			_target.x = _position.x;
			_target.y = _position.y;
		}
		
	}

}