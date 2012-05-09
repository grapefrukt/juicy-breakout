package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.events.JuicyEvent;
	import com.grapefrukt.games.juicy.Settings;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.GTween;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Block extends GameObject {
		
		private var _collidable:Boolean = true;
		
		public function Block(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			
			// 0,0 is at center of block to make effects easier
			graphics.beginFill(0xff0000);
			graphics.drawRect(-Settings.BLOCK_W / 2, -Settings.BLOCK_H / 2, Settings.BLOCK_W, Settings.BLOCK_H);
		}
		
		public function collide(ball:Ball):void {
			_collidable = false;
			
			if (Settings.EFFECT_TWEEN_BLOCK_DESTRUCTION) {
				
				new GTween(this, .2, { scaleY : 0, scaleX : 0  }, { ease : Quadratic.easeOut } );
				
				if (Settings.EFFECT_BLOCK_ROTATE) new GTween(this, .1, { rotation : Math.random() > .5 ? 90 : -90 }, { ease : Quadratic.easeIn } );
				
				if (Settings.EFFECT_BLOCK_PUSH) {
					var v:Point = new Point(this.x - ball.x, this.y - ball.y);
					v.normalize( ball.velocity * 1);
					
					velocityX += v.x;
					velocityY += v.y;
				}
				
			} else {	
				remove();
			}
			
			dispatchEvent(new JuicyEvent(JuicyEvent.BLOCK_DESTROYED));
		}
		
		private function handleRemoveTweenComplete(g:GTween):void {
			remove();
		}
		
		public function get collidable():Boolean {
			return _collidable;
		}
		
	}

}