package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.Settings;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Paddle extends Block {
		
		private var _face:PaddleFace;
		
		public function Paddle() {
			super(Settings.STAGE_W / 2, Settings.STAGE_H + Settings.PADDLE_H / 2 - 50);
			_collisionW = Settings.PADDLE_W;
			_collisionH = Settings.PADDLE_H;
			render(Settings.COLOR_PADDLE);
			
			_face = new PaddleFace();
			_gfx.addChild(_face);
		}
		
		override public function collide(ball:Ball):void {
			//super.collide(ball);
		}
		
		override public function update(timeDelta:Number = 1):void {
			super.update(timeDelta);
			_face.visible = Settings.EFFECT_PADDLE_FACE;
			_face.mouth.gotoAndStop(Settings.EFFECT_PADDLE_SMILE);
		}
		
		public function lookAt(ball:Ball):void {
			if (Settings.EFFECT_PADDLE_LOOK_AT_BALL) {
				_face.eye_l.rotation = -Math.atan2(
					this.x + _face.eye_l.x - ball.x, 
					this.y + _face.eye_l.y - ball.y) * 180 / Math.PI;
				_face.eye_r.rotation = -Math.atan2(
					this.x + _face.eye_r.x - ball.x, 
					this.y + _face.eye_r.y - ball.y) * 180 / Math.PI;
			} else {
				_face.eye_l.rotation = _face.eye_r.rotation = 0;
			}
		}
		
		override protected function render(color:uint):void {
			_gfx.graphics.clear();
			_gfx.graphics.beginFill(color);
			// 0,0 is at center of block to make effects easier
			_gfx.graphics.drawRect(-Settings.PADDLE_W / 2, -Settings.PADDLE_H / 2, Settings.PADDLE_W, Settings.PADDLE_H);
		}
		
	}

}