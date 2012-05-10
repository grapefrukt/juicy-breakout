package com.grapefrukt.games.juicy {
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Settings {
		
		public static const STAGE_W:int = 800;
		public static const STAGE_H:int = 600;
		
		static public const BLOCK_W:Number = 50;
		static public const BLOCK_H:Number = 20;
		
		static public const PADDLE_W:Number = 100;
		static public const PADDLE_H:Number = 100;
		
		static public var EFFECT_SCREEN_SHAKE_POWER:Number = 0;
		
		static public var EFFECT_TWEEN_BLOCK_DESTRUCTION:Boolean = true;
			static public var EFFECT_BLOCK_PUSH:Boolean = true;
			static public var EFFECT_BLOCK_ROTATE:Boolean = true;
			static public var EFFECT_BLOCK_GRAVITY:Boolean = true;
			static public var EFFECT_BLOCK_DARKEN:Boolean = true;
			
		static public var EFFECT_BALL_STRETCH:Boolean = true;
		static public var EFFECT_BALL_DRAW_TRAILS:Boolean = true;
		
		static public const BALL_MAX_VELOCITY:Number = 5;
		static public const BALL_MIN_VELOCITY:Number = 4;
		
		static public const MOUSE_GRAVITY_POWER:Number = .001;
		static public const MOUSE_GRAVITY_MAX:Number = .05;
		static public const BALL_VELOCITY_LOSS:Number = .01;
	}

}