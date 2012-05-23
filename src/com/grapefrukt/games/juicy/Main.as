package com.grapefrukt.games.juicy {
	import com.grapefrukt.games.general.collections.GameObjectCollection;
	import com.grapefrukt.games.general.particles.ParticlePool;
	import com.grapefrukt.games.general.particles.ParticleSpawn;
	import com.grapefrukt.games.juicy.effects.BouncyLine;
	import com.grapefrukt.games.juicy.effects.particles.BallImpactParticle;
	import com.grapefrukt.games.juicy.effects.particles.BlockShatterParticle;
	import com.grapefrukt.games.juicy.effects.particles.ConfettiParticle;
	import com.grapefrukt.games.juicy.events.JuicyEvent;
	import com.grapefrukt.games.juicy.gameobjects.Ball;
	import com.grapefrukt.games.juicy.gameobjects.Block;
	import com.grapefrukt.games.juicy.gameobjects.Paddle;

	import com.grapefrukt.input.LazyKeyboard;
	import com.grapefrukt.Timestep;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.ColorTransformPlugin;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Main extends Sprite {
		
		private var _blocks		:GameObjectCollection;
		private var _balls		:GameObjectCollection;
		private var _lines		:GameObjectCollection;
		private var _timestep	:Timestep;
		private var _screenshake:Shaker;
		
		private var _paddle		:Paddle;
		
		private var _particles_impact:ParticlePool;
		private var _particles_shatter:ParticlePool;
		private var _particles_confetti:ParticlePool;
		
		private var _mouseDown	:Boolean;
		private var _mouseVector:Point;

		private var _toggler	:Toggler;
		
		private var _backgroundGlitchForce		:Number;
		private var _soundBlockHitCounter		:int;
		private var _soundLastTimeHit			:int;
		
		private var _keyboard	:LazyKeyboard;
		private var _slides:Slides;
		
		public function Main() {
			ColorTransformPlugin.install();
			
			SoundManager.init();
			SoundManager.soundControl.addEventListener(Event.INIT, handleInit);
		}
		
		private function handleInit(e:Event):void {
			_particles_confetti = new ParticlePool(ConfettiParticle);
			addChild(_particles_confetti);
			
			_blocks = new GameObjectCollection();
			_blocks.addEventListener(JuicyEvent.BLOCK_DESTROYED, handleBlockDestroyed, true);
			addChild(_blocks);
			
			// we want to draw these under the ball, that's why it's added here
			_lines = new GameObjectCollection();
			addChild( _lines );

			_balls = new GameObjectCollection();
			_balls.addEventListener(JuicyEvent.BALL_COLLIDE, handleBallCollide, true);
			addChild(_balls);
			
			_particles_impact = new ParticlePool(BallImpactParticle);
			addChild(_particles_impact);
			
			_particles_shatter = new ParticlePool(BlockShatterParticle);
			addChild(_particles_shatter);
			
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseToggle);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseToggle);
			
			_timestep = new Timestep();
			_timestep.gameSpeed = 1;
			
			_mouseVector = new Point;
			
			_screenshake = new Shaker(this);
			
			_toggler = new Toggler(Settings);
			parent.addChild(_toggler);
			
			_slides = new Slides();
			_slides.visible = false;
			parent.addChild(_slides);
			
			_keyboard = new LazyKeyboard(stage);
			
			reset();
		}

		public function drawBackground():void {
			graphics.clear();
			if ( Settings.EFFECT_BACKGROUND_COLOR_GLITCH && _backgroundGlitchForce > 0.01 ) {
				graphics.beginFill(Settings.COLOR_BACKGROUND * ( 3 * Math.random() ) );
				_backgroundGlitchForce *= 0.8;
			}
			else 
			{
				graphics.beginFill(Settings.COLOR_BACKGROUND );
			}
			graphics.drawRect(5, 5, Settings.STAGE_W-10, Settings.STAGE_H);
		}
		
		public function reset():void {
			
			_soundBlockHitCounter = 0;
			drawBackground();
			
			_blocks.clear();
			_balls.clear();
			_lines.clear();
			
			_particles_impact.clear();
			
			for (var j:int = 0; j < Settings.NUM_BALLS; j++) {
				addBall();
			}
			
			for (var i:int = 0; i < 80; i++) {
				var block:Block = new Block( 120 + (i % 10) * (Settings.BLOCK_W + 10), 30 + 47.5 + int(i / 10) * (Settings.BLOCK_H + 10));
				_blocks.add(block);
			}
			
			var buffer:Number = Settings.EFFECT_BOUNCY_LINES_DISTANCE_FROM_WALLS;
			_lines.add( new BouncyLine( buffer, buffer, 						Settings.STAGE_W - buffer, buffer ) );
			_lines.add( new BouncyLine( buffer, buffer, 						buffer, Settings.STAGE_H ) );
			_lines.add( new BouncyLine( Settings.STAGE_W - buffer, 	buffer, 	Settings.STAGE_W - buffer, Settings.STAGE_H ) );
			
			_paddle = new Paddle();
			_blocks.add(_paddle);
		}
		
		private function handleEnterFrame(e:Event):void {
			_timestep.tick();
			
			_soundLastTimeHit++;
			
			if (!Settings.SOUND_MUSIC) {
				SoundManager.soundControl.stopSound("music-0");
			} else if (!SoundManager.soundControl.getSound("music-0").isPlaying) {
				SoundManager.play("music");
			}
			
			if (_keyboard.keyIsDown(Keyboard.CONTROL) || _slides.visible) {
				_timestep.gameSpeed = 0;
			} else if (_keyboard.keyIsDown(Keyboard.SHIFT)) {
				_timestep.gameSpeed = .1;
			} else {
				_timestep.gameSpeed = 1;
			}
			
			GTween.timeScaleAll = _timestep.gameSpeed;
			
			drawBackground();
			
			_balls.update(_timestep.timeDelta);
			_blocks.update(_timestep.timeDelta);
			_lines.update(_timestep.timeDelta);
			_screenshake.update(_timestep.timeDelta);
			
			_paddle.lookAt(Ball(_balls.collection[0]));
			
			if (Settings.EFFECT_PADDLE_STRETCH) {
				_paddle.scaleX = 1 + Math.abs(_paddle.x - mouseX) / 100;
				_paddle.scaleY = 1.5 - _paddle.scaleX * .5;
			} else {
				_paddle.scaleX = _paddle.scaleY = 1;
			}
			_paddle.x = mouseX;
			
			var screen_buffer:Number = 0.5 * Settings.EFFECT_BOUNCY_LINES_WIDTH + Settings.EFFECT_BOUNCY_LINES_DISTANCE_FROM_WALLS;
			for each(var ball:Ball in _balls.collection) {
				if (ball.x < screen_buffer 						&& ball.velocityX < 0) ball.collide(-1, 1);
				if (ball.x > Settings.STAGE_W - screen_buffer 	&& ball.velocityX > 0) ball.collide( -1, 1);
				if (ball.y < screen_buffer 						&& ball.velocityY < 0) ball.collide(1, -1);
				if (ball.y > Settings.STAGE_H 					&& ball.velocityY > 0) ball.collide(1, -1);
				
				// line ball collision
				for each ( var line:BouncyLine in _lines.collection) {
					line.checkCollision( ball );
				}
				
				
				if (_mouseDown) {
					_mouseVector.x = (ball.x - mouseX) * Settings.MOUSE_GRAVITY_POWER * _timestep.timeDelta;
					_mouseVector.y = (ball.y - mouseY) * Settings.MOUSE_GRAVITY_POWER * _timestep.timeDelta;
					if (_mouseVector.length > Settings.MOUSE_GRAVITY_MAX) _mouseVector.normalize(Settings.MOUSE_GRAVITY_MAX);
					
					ball.velocityX -= _mouseVector.x;
					ball.velocityY -= _mouseVector.y;
				}
				
				// hard limit for min vel
				if (ball.velocity < Settings.BALL_MIN_VELOCITY) {
					ball.velocity = Settings.BALL_MIN_VELOCITY;
				}
				
				// soft limit for max vel
				if (ball.velocity > Settings.BALL_MAX_VELOCITY) {
					ball.velocity -= ball.velocity * Settings.BALL_VELOCITY_LOSS * _timestep.timeDelta;
				}
				
				for each ( var block:Block in _blocks.collection) {
					// check for collisions
					if (block.collidable && isColliding(ball, block)) {
						
							// back the ball out of the block
							var v:Point = new Point(ball.velocityX, ball.velocityY);
							v.normalize(2);
							while (isColliding(ball, block)) {
								ball.x -= v.x;
								ball.y -= v.y;
							}
							
							block.collide(ball);
							
							// figure out which way to bounce
							
							// slicer powerup
							if (Settings.POWERUP_SLICER_BALL && !(block is Paddle))
							ball.collide(1, 1, block);
							// top
							else if (ball.y <= block.y - block.collisionH / 2 && ball.velocityY > 0) ball.collide(1, -1, block);
							// bottom
							else if (ball.y >= block.y + block.collisionH / 2 && ball.velocityY < 0) ball.collide(1, -1, block);
							// left
							else if (ball.x <= block.x - block.collisionW / 2) ball.collide(-1, 1, block);
							// right
							else if (ball.x >= block.x + block.collisionW / 2) ball.collide(-1, 1, block);
							// wtf!
							else ball.collide(-1, -1, block);
							
							break; // only collide with one block per update
						}
				}
			}
		}
		
		private function isColliding(ball:Ball, block:Block):Boolean {
			return 	ball.x > block.x - block.collisionW / 2 && ball.x < block.x + block.collisionW / 2 &&
					ball.y > block.y - block.collisionH / 2 && ball.y < block.y + block.collisionH / 2
		}
		
		private function handleBallCollide(e:JuicyEvent):void {
			
			if( e.block != null && e.block != _paddle )
				_backgroundGlitchForce = 0.05;
				
			if (Settings.EFFECT_PARTICLE_BALL_COLLISION) {
				ParticleSpawn.burst(	
					e.ball.x, 
					e.ball.y, 
					5, 
					90, 
					-Math.atan2(e.ball.velocityX, e.ball.velocityY) * 180 / Math.PI, 
					e.ball.velocity * 5, 
					.5,
					_particles_impact
				);
			}
			
			if (Settings.EFFECT_SCREEN_SHAKE) _screenshake.shake( -e.ball.velocityX * Settings.EFFECT_SCREEN_SHAKE_POWER, -e.ball.velocityY * Settings.EFFECT_SCREEN_SHAKE_POWER);
			
			if (Settings.EFFECT_BLOCK_JELLY) {
				for each (var block:Block in _blocks.collection) {
					//var dist:Number = block.getDistance(e.ball);
					//dist = dist / Settings.STAGE_W;
					//dist = MathUtil.clamp(dist, 1, 0) * .2;
					block.jellyEffect(.2, Math.random() * .02);
				}
			}
			
			e.ball.velocity = Settings.BALL_MAX_VELOCITY;
			
			// wall collision
			if (e.block is Paddle) {
				SoundManager.play("ball-paddle");
				
				
				if (Settings.EFFECT_PARTICLE_PADDLE_COLLISION) {
					ParticleSpawn.burst(	
						e.ball.x, 
						e.ball.y, 
						20, 
						90, 
						-180, 
						600, 
						1,
						_particles_confetti
					);
				}
				
			} else if (e.block) {
				// SoundManager.play("ball-block");	
				_soundBlockHitCounter++;

				if ( _soundLastTimeHit > 60 ) 
					_soundBlockHitCounter = 0;
					
				_soundLastTimeHit = 0;
				SoundManager.playSoundId( "ball-block", _soundBlockHitCounter );
			} else {
				SoundManager.play("ball-wall");
			}		
		}
		
		private function handleBlockDestroyed(e:JuicyEvent):void {
			if (Settings.EFFECT_PARTICLE_BLOCK_SHATTER) {
				ParticleSpawn.burst(	
					e.ball.x, 
					e.ball.y, 
					5, 
					45, 
					-Math.atan2(e.ball.velocityX, e.ball.velocityY) * 180 / Math.PI, 
					50 + e.ball.velocity * 10, 
					.5,
					_particles_shatter
				);
			}
		}
		
		private function handleKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SPACE) reset();
			if (e.keyCode == Keyboard.B) addBall();
			if (e.keyCode == Keyboard.S) _screenshake.shakeRandom(4);
			if (e.keyCode == Keyboard.NUMBER_1) _toggler.setAll(true);
			if (e.keyCode == Keyboard.NUMBER_2) _toggler.setAll(false);
			if (e.keyCode == Keyboard.P) {
				var b:Ball = _balls.collection[0] as Ball;
				ParticleSpawn.burst(b.x, b.y, 10, 360, Math.atan2(b.velocityY, b.velocityX) * 180 / Math.PI, 100, .1, _particles_impact);
			}
		}
		
		private function handleMouseToggle(e:MouseEvent):void {
			_mouseDown = e.type == MouseEvent.MOUSE_DOWN;
		}
		
		private function addBall():void {
			_balls.add(new Ball(Settings.STAGE_W / 2, Settings.STAGE_H / 2));
		}
		
	}
	
}