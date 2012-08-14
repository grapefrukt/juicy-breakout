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
		static public const PADDLE_H:Number = 30;
		
		[header("Colors")]
		[o("91")] static public var EFFECT_SCREEN_COLORS				:Boolean = false;
		
		[header("Tweening")]
		[o("A1")] static public var EFFECT_TWEENIN_ENABLED				:Boolean = false;
		[o("A2")] static public var EFFECT_TWEENIN_PROPERTY_Y			:Boolean = true;
		[o("A3")] static public var EFFECT_TWEENIN_PROPERTY_ROTATION	:Boolean = false;
		[o("A4")] static public var EFFECT_TWEENIN_PROPERTY_SCALE		:Boolean = false;
		[min("0")] [max("1")]
		[o("A5")] static public var EFFECT_TWEENIN_DELAY				:Number = 0;
		[min("0.01")] [max("3")]
		[o("A6")] static public var EFFECT_TWEENIN_DURATION				:Number = .7;
		[min("0")] [max("3")]
		[o("A7")] static public var EFFECT_TWEENIN_EQUATION				:int = 0;
		
		[header("Stretch and squeeze")]
		[o("B1")] static public var EFFECT_PADDLE_STRETCH				:Boolean = false;
		
		[o("B2")] static public var EFFECT_BALL_EXTRA_SCALE				:Boolean = false;
		[o("B3")] static public var EFFECT_BALL_ROTATE					:Boolean = false;
		[o("B4")] static public const EFFECT_BALL_ROTATE_ANIMATED		:Boolean = false;
		[o("B5")] static public var EFFECT_BALL_STRETCH					:Boolean = false;
		[o("B6")] static public var EFFECT_BALL_STRETCH_ANIMATED		:Boolean = false;
		[o("B7")] static public var EFFECT_BALL_GLOW					:Boolean = false;
		
		[o("C1")] static public var EFFECT_BLOCK_JELLY					:Boolean = false;
		[o("C2")] static public var EFFECT_BOUNCY_LINES_ENABLED			:Boolean = false;
		
		[header("Sounds")]
		[o("E1")] static public var SOUND_WALL							:Boolean = false;
		[o("E2")] static public var SOUND_BLOCK							:Boolean = false;
		[o("E3")] static public var SOUND_PADDLE						:Boolean = false;
		[o("E4")] static public var SOUND_MUSIC							:Boolean = false;
		
		[header("Particles")]
		[o("G0")] static public var EFFECT_PARTICLE_BALL_COLLISION		:Boolean = false;
		
		[min("0")] [max("3")]
		[o("G01")] static public var EFFECT_BLOCK_DESTRUCTION_DURATION	:Number = 2;
		[o("G02")] static public var EFFECT_BLOCK_SCALE					:Boolean = false;
		[o("G03")] static public var EFFECT_BLOCK_GRAVITY				:Boolean = false;
		[o("G04")] static public var EFFECT_BLOCK_PUSH					:Boolean = false;
		[o("G05")] static public var EFFECT_BLOCK_ROTATE				:Boolean = false;
		[o("G06")] static public var EFFECT_BLOCK_DARKEN				:Boolean = false;
		[o("G07")] static public var EFFECT_BLOCK_SHATTER				:Boolean = false;
		
		[o("G08")] static public var EFFECT_PARTICLE_BLOCK_SHATTER		:Boolean = false;
		[o("G09")] static public var EFFECT_PARTICLE_PADDLE_COLLISION	:Boolean = false;
		
		[o("G10")] static public var EFFECT_BALL_TRAIL					:Boolean = false;
		[min("5")] [max("100")]
		[o("G11")] static public const EFFECT_BALL_TRAIL_SCALE			:Boolean = true;
		[o("G12")] static public const EFFECT_BALL_TRAIL_LENGTH			:int = 30;
		
		[header("Screen shake")]
		[o("H0")] static public var EFFECT_SCREEN_SHAKE					:Boolean = false;
		[min("0")] [max("1")]
		[o("H1")] static public var EFFECT_SCREEN_SHAKE_POWER			:Number = .5;
		
		[header("Personality")]
		[o("I1")] static public var EFFECT_PADDLE_FACE					:Boolean = false;
		[o("I2")] static public var EFFECT_PADDLE_LOOK_AT_BALL			:Boolean = false;
		[min("1")] [max("100")]
		[o("I3")] static public var EFFECT_PADDLE_SMILE					:int = 0;
		[min("1")] [max("300")]
		[o("I4")] static public var EFFECT_PADDLE_EYE_SIZE				:int = 1;
		[min("10")] [max("60")]
		[o("I5")] static public var EFFECT_PADDLE_EYE_SEPARATION		:int = 25;
		
		[header("Finish him")]
		[o("J1")] static public var EFFECT_SCREEN_COLOR_GLITCH			:Boolean = false;
		[o("J2")] static public const POWERUP_SLICER_BALL 				:Boolean = false;
		
		[header("Other")]
		[min("0")] [max("1")]
		static public var NUM_BALLS										:int = 1;
		
		[min("0")] [max("20")]
		static public const EFFECT_BLOCK_SHATTER_ROTATION		:Number = 5;
		[min("0")] [max("5")]
		static public const EFFECT_BLOCK_SHATTER_FORCE			:Number = 2;
		
		[min("0")] [max("100")]
		static public const EFFECT_BOUNCY_LINES_STRENGHT	:Number = 10;
		static public const EFFECT_BOUNCY_LINES_DISTANCE_FROM_WALLS	:Number = 5;
		[min("1")] [max("100")]
		static public const EFFECT_BOUNCY_LINES_WIDTH		:Number = 20;
		
		static public const BALL_MAX_VELOCITY				:Number = 5;
		static public const BALL_MIN_VELOCITY				:Number = 4;
		
		static public const MOUSE_GRAVITY_POWER		:Number = .001;
		static public const MOUSE_GRAVITY_MAX		:Number = .05;
		static public const BALL_VELOCITY_LOSS		:Number = .01;
		
		static public const COLOR_BACKGROUND	:uint = 0x490a3d;
		static public const COLOR_BLOCK			:uint = 0xbd1550;
		static public const COLOR_BALL			:uint = 0xf8ca00;
		static public const COLOR_PADDLE		:uint = 0xe97f02;
		static public const COLOR_TRAIL			:uint = 0x8a9b0f;
		static public const COLOR_SPARK			:uint = 0xffffff;
		static public const COLOR_BOUNCY_LINES	:uint = 0xbd1550;
		
	}

}