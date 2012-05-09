package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.events.JuicyEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Ball extends GameObject {
		
		public function Ball(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			
			graphics.beginFill(0x000000);
			graphics.drawCircle(0, 0, 5);
			
			var v:Point = Point.polar(5, Math.random() * Math.PI * 2);
			velocityX = v.x;
			velocityY = v.y;
		}
		
		public function collide(velocityMultiplierX:Number, velocityMultiplierY:Number, block:Block = null):void {
			velocityX *= velocityMultiplierX;
			velocityY *= velocityMultiplierY;
			dispatchEvent(new JuicyEvent(JuicyEvent.BALL_COLLIDE, this, block));
		}
		
	}

}