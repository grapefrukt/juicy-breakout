package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Block extends GameObject {
		
		static public const DEFAULT_W:Number = 50;
		static public const DEFAULT_H:Number = 20;
		
		public function Block(x:Number, y:Number, width:Number = DEFAULT_W, height:Number = DEFAULT_H) {
			this.x = x;
			this.y = y;
			
			graphics.beginFill(0xff0000);
			graphics.drawRect(0, 0, width, height);
		}
		
	}

}