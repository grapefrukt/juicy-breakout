package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.Settings;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Paddle extends Block {
		
		public function Paddle() {
			super(Settings.STAGE_W / 2, Settings.STAGE_H + Settings.PADDLE_H / 2 - 50);
			_collisionW = Settings.PADDLE_W;
			_collisionH = Settings.PADDLE_H;
			render(Settings.COLOR_PADDLE);
		}
		
		override public function collide(ball:Ball):void {
			//super.collide(ball);
		}
		
		override public function update(timeDelta:Number = 1):void {
			super.update(timeDelta);
		}
		
		override protected function render(color:uint):void {
			_gfx.graphics.clear();
			_gfx.graphics.beginFill(color);
			// 0,0 is at center of block to make effects easier
			_gfx.graphics.drawRect(-Settings.PADDLE_W / 2, -Settings.PADDLE_H / 2, Settings.PADDLE_W, Settings.PADDLE_H);
		}
		
	}

}