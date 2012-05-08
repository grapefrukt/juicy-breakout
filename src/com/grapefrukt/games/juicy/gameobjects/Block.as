package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.Settings;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Block extends GameObject {
		
		public function Block(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			
			// 0,0 is at center of block to make effects easier
			graphics.beginFill(0xff0000);
			graphics.drawRect(-Settings.BLOCK_W / 2, -Settings.BLOCK_H / 2, Settings.BLOCK_W, Settings.BLOCK_H);
		}
		
	}

}