package com.grapefrukt.games.juicy.gameobjects {
	import com.grapefrukt.display.utilities.DrawGeometry;
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.effects.SliceEffect;
	import com.grapefrukt.games.juicy.events.JuicyEvent;
	import com.grapefrukt.games.juicy.Settings;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.ColorTransformPlugin;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Block extends GameObject {
		
		protected var _collisionW:Number = Settings.BLOCK_W;
		protected var _collisionH:Number = Settings.BLOCK_H;
		
		protected var _collidable:Boolean = true;
		protected var _gfx:Shape;
		
		private var _sliceEffect:SliceEffect;
		
		public function Block(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			
			_gfx = new Shape();
			addChild(_gfx);
			
			render(Settings.COLOR_BLOCK);
		}
		
		public function collide(ball:Ball):void {
			_collidable = false;
			
			// little hack to get the animation complete callback for all cominations of rotation/scaling
			var delayDestruction:Boolean = false;
			
			if (Settings.EFFECT_BLOCK_DARKEN) transform.colorTransform = new ColorTransform(.7, .7, .8);
			
			if (Settings.EFFECT_BLOCK_PUSH) {
				var v:Point = new Point(this.x - ball.x, this.y - ball.y);
				v.normalize( ball.velocity * 1);
				
				velocityX += v.x;
				velocityY += v.y;
				delayDestruction = true;
			}
			
			// move block in front
			parent.setChildIndex(this, parent.numChildren - 1);
			
			_sliceEffect = new SliceEffect(_gfx, null);
			addChild(_sliceEffect);
			_gfx.visible = false;
			
			if (Settings.EFFECT_BLOCK_ROTATE && !Settings.EFFECT_BLOCK_SHATTER) {
				_sliceEffect.slices[0].velocityR = Math.random() > .5 ? Settings.EFFECT_BLOCK_SHATTER_ROTATION : -Settings.EFFECT_BLOCK_SHATTER_ROTATION;
				delayDestruction = true;
			}
			
			if (Settings.EFFECT_BLOCK_SHATTER) {
				_sliceEffect.slice(
					new Point(ball.x - this.x + ball.velocityX * 10, ball.y - this.y + ball.velocityY * 10),
					new Point(ball.x - this.x - ball.velocityX * 10, ball.y - this.y - ball.velocityY * 10) 
				);
				delayDestruction = true;
			}
			
			if (Settings.EFFECT_BLOCK_SCALE) {
				for each (var slice:Shape in _sliceEffect.slices) {
					new GTween(slice, Settings.EFFECT_BLOCK_DESTRUCTION_DURATION, { scaleY : 0, scaleX : 0  }, { ease : Quadratic.easeOut } );
				}
				
				delayDestruction = true;
			}
			
			// if no animation is used, remove instantly
			if (!delayDestruction) {
				remove();
			} else {
				new GTween(this, Settings.EFFECT_BLOCK_DESTRUCTION_DURATION, null, { onComplete : handleRemoveTweenComplete } );
			}
			
			dispatchEvent(new JuicyEvent(JuicyEvent.BLOCK_DESTROYED));
		}
		
		override public function update(timeDelta:Number = 1):void {
			super.update(timeDelta);
			
			if (_sliceEffect) _sliceEffect.update(timeDelta);
			
			if (Settings.EFFECT_BLOCK_GRAVITY && !_collidable) {
				velocityY += .4 * timeDelta;
			}
		}
		
		private function handleRemoveTweenComplete(g:GTween):void {
			remove();
		}
		
		protected function render(color:uint):void {
			_gfx.graphics.clear();
			_gfx.graphics.beginFill(color);
			// 0,0 is at center of block to make effects easier
			_gfx.graphics.drawRect(-Settings.BLOCK_W / 2, -Settings.BLOCK_H / 2, Settings.BLOCK_W, Settings.BLOCK_H);
		}
		
		public function get collidable():Boolean {
			return _collidable;
		}
		
		public function get collisionW():Number {
			return _collisionW;
		}
		
		public function get collisionH():Number {
			return _collisionH;
		}
		
	}

}