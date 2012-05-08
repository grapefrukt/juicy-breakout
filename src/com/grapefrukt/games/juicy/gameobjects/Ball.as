package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Ball extends GameObject {
		
		public function Ball(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			
			graphics.beginFill(0x000000);
			graphics.drawCircle(0, 0, 10);
		}
		
	}

}