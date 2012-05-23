package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.Settings;
	import com.grapefrukt.math.MathUtil;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Paddle extends Block {
		
		private var _face:PaddleFace;
		private var _happyExtraScale:Number;
		
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
			_happyExtraScale = 10;
		}
		
		override public function update(timeDelta:Number = 1):void {
			super.update(timeDelta);
			_face.visible = Settings.EFFECT_PADDLE_FACE;
			_face.mouth.gotoAndStop(Settings.EFFECT_PADDLE_SMILE);
			
			_face.eye_l.x = -Settings.EFFECT_PADDLE_EYE_SEPARATION;
			_face.eye_r.x = Settings.EFFECT_PADDLE_EYE_SEPARATION;
			
			_happyExtraScale *= 0.95;
			_face.eye_l.scaleX = _face.eye_l.scaleY = 1 + Settings.EFFECT_PADDLE_EYE_SIZE / 100;
			_face.eye_r.scaleX = _face.eye_r.scaleY = 1 + Settings.EFFECT_PADDLE_EYE_SIZE / 100;
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
			
			/*if ( _happyExtraScale > 0.01 ) 
			{
				_face.mouth.scaleX = 1 + MathUtil.clamp( _happyExtraScale );
				_face.mouth.scaleY = 1 + MathUtil.clamp( _happyExtraScale );
			}
			else
			{*/
				_face.mouth.scaleX = 1;
				
				var distance:Number = Math.sqrt(
					Math.pow( this.x - ball.x, 2 ) + 
					Math.pow( this.y - ball.y, 2 ) );
				
				distance /= 500;
				distance = 1 - MathUtil.clamp( distance - 0.1, 1, 0 );
				distance += _happyExtraScale;
				smile( distance );
				// _face.mouth.scaleY = 0.1;
			// }
		}
		
		public function smile( how_much:Number ):void {
			var t:Number = 0;
			if ( how_much < 0.4 ) {
				t = -1 + ( how_much / 0.4 );
				_face.mouth.scaleY = t;
			}
			else if ( how_much <= 1 ) {
				_face.mouth.scaleY = 0.1;
			} else {
				t = 0.1 + ( ( MathUtil.clamp( how_much, 2, 0 ) - 1.0 ) / 1.0 ) * 0.9;
				_face.mouth.scaleY = t;
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