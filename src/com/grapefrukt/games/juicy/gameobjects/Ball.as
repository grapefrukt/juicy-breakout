package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Ball extends GameObject {
		
		public var velocityX:Number = 0;
		public var velocityY:Number = 0;
		
		public function Ball(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			
			graphics.beginFill(0x000000);
			graphics.drawCircle(0, 0, 5);
			
			var v:Point = Point.polar(10, Math.random() * Math.PI * 2);
			velocityX = v.x;
			velocityY = v.y;
		}
		
		override public function update(timeDelta:Number = 1):void {
			super.update(timeDelta);
			x += velocityX * timeDelta;
			y += velocityY * timeDelta;
		}
		
		public function bounce(multiplierX:Number, multiplierY:Number):void {
			velocityX *= multiplierX;
			velocityY *= multiplierY;
		}
	}

}