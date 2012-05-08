package com.grapefrukt.games.juicy {
	import com.grapefrukt.games.general.collections.GameObjectCollection;
	import com.grapefrukt.games.juicy.gameobjects.Ball;
	import com.grapefrukt.games.juicy.gameobjects.Block;
	import com.grapefrukt.Timestep;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Main extends Sprite {
		
		private var _blocks		:GameObjectCollection;
		private var _balls		:GameObjectCollection;
		private var _timestep	:Timestep;

		
		public function Main() {
			_blocks = new GameObjectCollection();
			addChild(_blocks);
			
			_balls = new GameObjectCollection();
			addChild(_balls);
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			_timestep = new Timestep();
			
			reset();
		}
		
		public function reset():void {
			_blocks.clear();
			_balls.clear();			
			
			_balls.add(new Ball(Settings.STAGE_W / 2, Settings.STAGE_H - 100));
			
			for (var i:int = 0; i < 80; i++) {
				var block:Block = new Block( 82.5 + (i % 10) * Block.DEFAULT_W * 1.3, 47.5 + int(i / 10) * Block.DEFAULT_H * 1.3);
				_blocks.add(block);
			}
		}
		
		private function handleEnterFrame(e:Event):void {
			_timestep.tick();
			_balls.update(_timestep.timeDelta);
			_blocks.update(_timestep.timeDelta);
			
			for each(var ball:Ball in _balls.collection) {
				if (ball.x < 0 && ball.velocityX < 0) ball.bounce(-1, 1);
				if (ball.x > Settings.STAGE_W && ball.velocityX > 0) ball.bounce( -1, 1);
				if (ball.y < 0 && ball.velocityY < 0) ball.bounce(1, -1);
				if (ball.y > Settings.STAGE_H && ball.velocityY > 0) ball.bounce(1, -1);
			}
		}
		
		
		private function handleKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SPACE) reset();
		}
	}
	
}